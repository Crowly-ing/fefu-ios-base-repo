import UIKit

struct ActivityTableViewVM {
    let date: String
    let activities: [ActivityTableCellVM]
}

class ActivityListController: UIViewController {
    @IBOutlet weak var startActivityButton: PrimaryButton!
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var activityList: UITableView!
    
    private let data: [ActivityTableViewVM] = {
        let yesterdayActivities: [ActivityTableCellVM] = [
            ActivityTableCellVM(distance: "14.32 км",
                                duration: "2 часа 46 минут",
                                title: "Велосипед",
                                timeAgo: "14 часов назад",
                                icon: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(),
                                start: "14:49",
                                end: "16:31"
                               )
        ]
        
        let decemberActivities: [ActivityTableCellVM] = [
            ActivityTableCellVM(distance: "14.32 км",
                                duration: "2 часа 46 минут",
                                title: "Велосипед",
                                timeAgo: "14 часов назад",
                                icon: UIImage(systemName: "bicycle.circle.fill") ?? UIImage(),
                                start: "14:49",
                                end: "16:31"
                               )
        ]
        return [
            ActivityTableViewVM(date: "Вчера", activities: yesterdayActivities),
            ActivityTableViewVM(date: "Декабрь 1991", activities: decemberActivities)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityList.delegate = self
        activityList.dataSource = self
        
        let cellNib = UINib(nibName: "ActivityTableViewCell", bundle: nil)
        activityList.register(cellNib, forCellReuseIdentifier: "ActivityTableViewCell")
        
        commonInit()
    }
    
    private func commonInit() {
        self.title = "Активности"
        
        self.startActivityButton.setTitle("Старт", for: .normal)
        
        emptyDataView.backgroundColor = .clear
        
        activityList.backgroundColor = .clear
        activityList.separatorStyle = .none
        
        emptyDataView.isHidden = false
        activityList.isHidden = true
    }
    
    @IBAction func didStartActivity(_ sender: Any) {
        emptyDataView.isHidden = true
        activityList.isHidden = false
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
