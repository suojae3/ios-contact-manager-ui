
import Foundation

// MARK: - PhoneBooks Init & Deinit
final class PhoneBook {
    
    @NotifyContactInfoChange
    var categorizedContactInfo = [User]()
        
    func setDelegate(with delegate: UpdatePhoneBookDelegate?) {
        _categorizedContactInfo.updateDelegate = delegate
    }

    deinit { print("PhoneBook has been deinit!!")}
}


// MARK: - Delegate
extension PhoneBook: UpdatePhoneBookDelegate {
    func update(userInfo: [User]) {
        categorizedContactInfo = userInfo
    }
}
    
