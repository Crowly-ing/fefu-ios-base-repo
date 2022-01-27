import UIKit
import CoreLocation

struct ActivityTableViewVM {
    let date: String
    let activities: [ActivityTableCellVM]
}

class ActivityListController: UIViewController {
    @IBOutlet weak var startActivityButton: PrimaryButton!
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var activityList: UITableView!
    private let CDHelper = CDController()
    @IBOutlet weak var segmentC: UISegmentedControl!
    
    private var data: [ActivityTableViewVM] = []
    var selectedSection: Int = 0
    
    func handleFetch() {
        print(selectedSection)
        if selectedSection == 0 {
            fetch()
        } else if selectedSection == 1 {
            fetchCommunity()
        }
        activityList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityList.delegate = self
        activityList.dataSource = self
        
        let cellNib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        activityList.register(cellNib, forCellReuseIdentifier: "ActivityTableViewCell")
        
        commonInit()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleFetch()
        self.activityList.reloadData()
    }
    
    private func commonInit() {
        self.title = "Активности"
        
        self.startActivityButton.setTitle("Старт", for: .normal)
        
        emptyDataView.backgroundColor = .clear
        
        activityList.backgroundColor = .clear
        activityList.separatorStyle = .none
        
        emptyDataView.isHidden = data.isEmpty
        activityList.isHidden = !data.isEmpty
        
        segmentC.addTarget(self, action: #selector(segmentHandler(_:)), for: .valueChanged)
    }
    
    private func fetch() {
        do {
            let rawActivities = try CDHelper.fetch()
            let activitiesViewModels: [ActivityTableCellVM] = rawActivities.map { activity in
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                
                return ActivityTableCellVM(distance: activity.distance ?? "",
                                         duration: activity.duration ?? "",
                                         title: activity.type ?? "",
                                         timeAgo: activity.date ?? "",
                                         icon: image,
                                         start: activity.start ?? "",
                                         end: activity.end ?? "",
                                         creatorName: "")
            }
            
            let group = Dictionary(grouping: activitiesViewModels) { activityVM in
                return activityVM.timeAgo
            }
            
            self.data = group.map { (key, values) in
                return ActivityTableViewVM(date: key, activities: values)
            }
        } catch {
            print(error)
        }
        
    }
    
    @objc func segmentHandler(_ sender: UISegmentedControl) {
        selectedSection = segmentC.selectedSegmentIndex
        handleFetch()
    }
    
    private func getDuration(first: String, second: String) -> String{
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: "en_US_POSIX")
        dataFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = dataFormatter.date(from: first)
        let endTime = dataFormatter.date(from: second)
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        let calendar = Calendar.current
        return formatter.localizedString(for: startTime!, relativeTo: endTime!)
        
        
    }
    
    private func fetchCommunity() {
        AuthService.activities { activities in
            DispatchQueue.main.async {
                print(activities)
                let activities: [ActivityTableCellVM] = activities.items.map { activity in
                    let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
                    var prevLocation: CLLocation? = nil
                    var distance: Double = 0
                    activity.geo_track .forEach({ location in
                        let location = CLLocation(latitude: location.lat, longitude: location.lon)
                        
                        if prevLocation != nil {
                            distance += location.distance(from: prevLocation!) / 1000
                        }
                        prevLocation = location
                    })
                    
                    return ActivityTableCellVM(distance: String(format: "%.2f", distance) + " км",
                                               duration: self.getDuration(first: activity.starts_at, second: activity.ends_at),
                                               title: activity.activity_type.name,
                                               timeAgo: activity.ends_at,
                                               icon: image,
                                               start: activity.starts_at,
                                               end: activity.ends_at,
                                               creatorName: activity.user.name)
                }
                
                let group = Dictionary(grouping: activities) { activityVM in
                    return activityVM.timeAgo
                }
                self.data = group.map { (key, values) in
                    return ActivityTableViewVM(date: key, activities: values)
                }
                
                //  reload data
                self.activityList.reloadData()
                print(self.data)
            }
            
        } onError: { err in
            print(err)
        }
    
    }
    
    @IBAction func didStartActivity(_ sender: Any) {
        let VC = ActivityTrackingController(nibName: "ActivityTrackingController", bundle: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension ActivityListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let VC = ActivityDetailsController(nibName: "ActivityDetailsController", bundle: nil)
        VC.bind(self.data[indexPath.section].activities[indexPath.row])
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension ActivityListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 20)
        header.text = data[section].date
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityData = self.data[indexPath.section].activities[indexPath.row]
        
        let dequeuedCell = activityList.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        
        guard let upcastedCell = dequeuedCell as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        
        upcastedCell.bind(activityData)
        
        return upcastedCell
    }
}


