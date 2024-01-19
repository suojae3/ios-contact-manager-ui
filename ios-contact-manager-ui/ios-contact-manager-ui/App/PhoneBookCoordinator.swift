
import UIKit

protocol RegisterUserInfoDelegate: AnyObject {
    func goToRegisterViewController()
}

final class PhoneBookCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    //Set Dependency
    private let phoneBook = PhoneBook()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let phoneBookViewController = PhoneBookViewController()
        phoneBookViewController.coordinator = self
        phoneBookViewController.userData = phoneBook.categorizedContactInfo //시작값 셋팅
        phoneBook.setDelegate(with: phoneBookViewController)
        navigationController.pushViewController(phoneBookViewController, animated: true)
    }
}

extension PhoneBookCoordinator: RegisterUserInfoDelegate {
    
    func goToRegisterViewController() {
        let storyboard = UIStoryboard(name: "RegisterViewController", bundle: nil)
        let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        registerViewController.phoneBook = phoneBook
        registerViewController.coordinator = self
        
        registerViewController.modalPresentationStyle = .formSheet
        navigationController.present(registerViewController, animated: true)
    }
}
