
import UIKit

// MARK: - init & deinit
final class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var phoneBook: PhoneBook?
    weak var coordinator: RegisterUserInfoDelegate?
    
    var isRightAgeInput = false
    var isRightNameInput = false
    var isRightPhoneNumInput = false
        
    @IBAction private func validateNameTextField(_ sender: UITextField) {
        let minCount = 2
        let maxCount = 12
        
        if validateCountCondition(input: sender.text ?? "", condition: (minCount, maxCount)){
            changeTextBorderColor(textField: nameTextField, color: UIColor.systemBlue.cgColor)
            isRightNameInput = true
        } else {
            changeTextBorderColor(textField: nameTextField, color: UIColor.systemPink.cgColor)
            isRightNameInput = false
        }
    }
    
    @IBAction private func validateAgeTextField(_ sender: UITextField) {
        let minCount = 1
        let maxCount = 3
        
        if validateCountCondition(input: sender.text ?? "", condition: (minCount, maxCount)) {
            changeTextBorderColor(textField: ageTextField, color: UIColor.systemBlue.cgColor)
            isRightAgeInput = true
        } else {
            changeTextBorderColor(textField: ageTextField, color: UIColor.systemPink.cgColor)
            isRightAgeInput = false
        }
    }
    
    // Textfield Delegate
    @IBAction private func phoneNumberTextFieldChanged(_ sender: UITextField) {
        print("연락처 입력 변화")

        let convertDigit = sender.text!.replacingOccurrences(of: #"\D"#, with: "", options: .regularExpression)

        switch convertDigit.count {
        case 0...3:
            phoneNumberTextField.text = convertDigit
            changeTextBorderColor(textField: phoneNumberTextField, color: UIColor.systemPink.cgColor)
            isRightPhoneNumInput = false
        case 4...7:
            phoneNumberTextField.text = convertDigit.prefix(3) + "-" + convertDigit.suffix(convertDigit.count-3)
            changeTextBorderColor(textField: phoneNumberTextField, color: UIColor.systemPink.cgColor)
            isRightPhoneNumInput = false
        case 8...11:
            let startIndex = convertDigit.index(convertDigit.startIndex, offsetBy: 3)
            let endingIndex = convertDigit.index(convertDigit.startIndex, offsetBy: convertDigit.count-5)
            let middleNumber = convertDigit[startIndex...endingIndex]
            phoneNumberTextField.text = convertDigit.prefix(3) + "-" + middleNumber + "-" + convertDigit.suffix(4)
            changeTextBorderColor(textField: phoneNumberTextField, color: UIColor.systemBlue.cgColor)
            isRightPhoneNumInput = true
        default:
            changeTextBorderColor(textField: phoneNumberTextField, color: UIColor.systemPink.cgColor)
            isRightPhoneNumInput = false
        }
    }
    
    @IBAction private func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard validateTextField() == true else { return }
        print("연락처 저장됨")
        phoneBook?.categorizedContactInfo.append(
            User(
                userID: UUID(),
                name: nameTextField.text ?? "",
                phoneNumber: phoneNumberTextField.text ?? "",
                age: Int(ageTextField.text ?? "") ?? 0
            )
        )
        nameIndexing.append(nameTextField.text ?? "")
        phoneNumIndexing.append(phoneNumberTextField.text ?? "")
        ageIndexing.append(Int(ageTextField.text ?? "") ?? 0)
        self.dismiss(animated: true)
    }
    
    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    deinit { print("RegisterViewController has been deinit!!") }
}

// MARK: - LifeCycle
extension RegisterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Validate Method
private extension RegisterViewController {
    
    // Alert
    func validateTextField() -> Bool {
        if !isRightNameInput {
            presentAlert(title: "입력에러", message: "이름 입력창을 확인해주세요", confirmTitle: "확인")
            return false
        }
        if !isRightAgeInput {
            presentAlert(title: "입력에러", message: "나이 입력창을 확인해주세요", confirmTitle: "확인")
            return false
        }
        if !isRightPhoneNumInput {
            presentAlert(title: "입력에러", message: "번호 입력창을 확인해주세요", confirmTitle: "확인")
            return false
        }
        return true
    }
    
    // TextCount
    func validateCountCondition(input: String, condition: (Int,Int)) -> Bool {
        guard input.count >= condition.0 else {
            print("2글자 이상의 이름을 입력해 주세요.")
            return false
        }
        guard input.count < condition.1 else {
            print("1~99의 숫자를 입력해 주세요.")
            return false
        }
        return true
    }
}


// MARK: - UI 관련 로직
private extension RegisterViewController {
    
    private func changeTextBorderColor(textField: UITextField, color: CGColor) {
        textField.layer.borderColor = color
        textField.layer.borderWidth = 2
    }
}
