
import UIKit

class ChangePasswordController: UIViewController {

    
    @IBOutlet weak var oldPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    @IBOutlet weak var newPass2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Изменить пароль"
        outletsInit()
    }


    private func outletsInit() {
        oldPass.layer.cornerRadius = 10
        newPass.layer.cornerRadius = 10
        newPass2.layer.cornerRadius = 10
    }
    
    @IBAction func exitBtnTap(_ sender: Any) {
    }
    
}
