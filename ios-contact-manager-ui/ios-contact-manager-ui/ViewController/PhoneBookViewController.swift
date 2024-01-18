
import UIKit

// MARK: - PhoneBookViewController Init & Deinit
final class PhoneBookViewController: UIViewController {
    
    let tableView = UITableView()
    var phoneBook: PhoneBook? 
    weak var coordinator: MainCoordinator?
    
    deinit { print("PhoneBookViewController has been deinit!!") }
}

// MARK: - LifeCycle
extension PhoneBookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneBook?.delegate = self 
        setupTableView()
        setupUI()
    }
}

// MARK: - Setup TableView
private extension PhoneBookViewController {
    func setupTableView() {
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PhoneBookTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PhoneBookTableViewCell.reuseID)
        setupTableHeaderView()
    }
    
    func setupTableHeaderView() {
        let header = HeaderView(frame: .zero)
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        tableView.tableHeaderView = header
    }

}

// MARK: - SetupUI
private extension PhoneBookViewController {
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}


// MARK: - TableView Delegate
extension PhoneBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBook?.categorizedContactInfo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell,
              let user = phoneBook?.categorizedContactInfo[indexPath.row]
        else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = "\(user.name)(\(user.age))"
        cell.phoneNumberLabel.text = user.phoneNumber
        return cell
    }
}
// MARK: - View Transition
extension PhoneBookViewController {
    @objc func addButtonTapped() {
        DispatchQueue.main.async {
            self.coordinator?.goToRegisterViewController()
        }
    }
}



// MARK: - Delegate
extension PhoneBookViewController: updatePhoneBookDelegate {
    func onUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
