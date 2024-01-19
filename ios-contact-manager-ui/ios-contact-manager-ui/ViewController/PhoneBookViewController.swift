
import UIKit

// MARK: - PhoneBookViewController Init & Deinit
final class PhoneBookViewController: UIViewController {
    
    var userData: [User]? = nil
    let tableView = UITableView()
    weak var coordinator: RegisterUserInfoDelegate?
    
    deinit { print("PhoneBookViewController has been deinit!!") }
}

// MARK: - LifeCycle
extension PhoneBookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return userData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
        guard let user = userData?[indexPath.row] else { return UITableViewCell() }
        
        cell.nameLabel.text = "\(user.name)(\(user.age))"
        cell.phoneNumberLabel.text = user.phoneNumber
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            userData?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
}
// MARK: - View Transition
private extension PhoneBookViewController {
    @objc func addButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            self?.coordinator?.goToRegisterViewController()
        }
    }
}


// MARK: - Delegate
extension PhoneBookViewController: UpdatePhoneBookDelegate {
    func update(userInfo: [User]) {
        userData = userInfo
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
