
import UIKit

extension UIViewController {
    
    func presentAlert(title: String,
                      message: String,
                      confirmTitle: String,
                      confirmAction: ((UIAlertAction) -> Void)? = nil,
                      completion: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default)
        alertViewController.addAction(confirmAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
