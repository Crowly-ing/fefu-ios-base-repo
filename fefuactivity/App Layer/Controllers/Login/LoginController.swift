import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var continueButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.continueButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    private func commonInit() {
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        
        self.title = "Войти"
        
        continueButton.setTitle("Продолжить", for: .normal)
    }
}
