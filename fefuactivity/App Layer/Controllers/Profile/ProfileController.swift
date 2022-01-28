import UIKit

class ProfileController: UIViewController {
    
    var data = [
        0: innerProfileModel(rowName: "", rowData: ""),
        1: innerProfileModel(rowName: "", rowData: ""),
        2: innerProfileModel(rowName: "", rowData: ""),
        3: innerProfileModel(rowName: "", rowData: "")
        
    ]
    
    let login = "Логин:"
    let name = "Имя или никнейм:"
    let password = "Пароль:"
    let gender = "Пол:"
    
    var logData = ""
    
    
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var profileContentView: UITableView!
    
    @IBAction func exitBtnTap(_ sender: Any) {
        AuthService.logout {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "token")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                
                vc?.modalPresentationStyle = .overFullScreen
                self.present(vc!, animated: true)
            }
            
        } onError: { err in
            print(err)
        }
    }
    
    
    private func sinit() {
        profileContentView.delegate = self
        profileContentView.dataSource = self
        self.title = "Профиль"
        
        profileContentView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        
        exitBtn.layer.cornerRadius = 10
        profileContentView.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sinit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AuthService.profile { profile in
            DispatchQueue.main.async {
                
                self.data[0] = innerProfileModel(rowName: self.login, rowData: profile.login)
                self.data[1] = innerProfileModel(rowName: self.name, rowData: profile.name)
                self.data[2] = innerProfileModel(rowName: self.password, rowData: "acces dehind")
                self.data[3] = innerProfileModel(rowName: self.gender, rowData: profile.gender.name)
                
                self.profileContentView.reloadData()
            }
        } onError: { err in
            
        }
    }
}

extension ProfileController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let vc = ChangePasswordController(nibName: "ChangePasswordController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProfileController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == 0 {
            count = 3
        } else {
            count = 1
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row =  indexPath.section == 1 ? 3 : indexPath.row
        let data = data[row]
        let cell = profileContentView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath)
        
        if indexPath.row == 2 {
            cell.accessoryType = .disclosureIndicator
        }
        
        guard let upcCell = cell as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        upcCell.bind(data!)
        
        return upcCell
    }
}
