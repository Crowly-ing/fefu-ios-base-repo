import UIKit

class RegistrationController: UIViewController {
    @IBOutlet weak var selectGender: UITextField!
    @IBOutlet weak var continueButton: PrimaryButton!
    
    private let selectGenderView = UIPickerView()
    
    private let gendersList = ["", "Женский", "Мужской"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectGenderView.dataSource = self
        selectGenderView.delegate = self
        
        commonInit()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.continueButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    }
    
    private func commonInit() {
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        
        self.title = "Регистрация"
        
        continueButton.setTitle("Продолжить", for: .normal)
        
        selectGender.layer.sublayerTransform = CATransform3DMakeTranslation(-10, 0, 0)
        selectGender.inputView = selectGenderView
    }
    
}

extension RegistrationController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectGender.text = gendersList[row]
        selectGender.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gendersList[row]
    }
}

extension RegistrationController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gendersList.count
    }
}

extension RegistrationController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
