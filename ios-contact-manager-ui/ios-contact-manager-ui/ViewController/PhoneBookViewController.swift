
import UIKit

// MARK: - PhoneBookViewController Init & Deinit
final class PhoneBookViewController: UIViewController {

    var searchedUserDataArray = [User]()
    
    var isFiltering2: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        return isActive
    }
    var isFiltering = false
    
    var userData: [User]? = nil
    let tableView = UITableView()
    weak var coordinator: RegisterUserInfoDelegate?
    
    deinit { print("PhoneBookViewController has been deinit!!") }
}

// MARK: - LifeCycle
extension PhoneBookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: self)
        
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = true
        
        
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
extension PhoneBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFiltering {
            print("필터링-셀 갯수")
            print(searchedUserDataArray.count)
            return searchedUserDataArray.count
        } else {
            print("안됨")
            return userData?.count ?? 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isFiltering {
            print("isFiltering on")
//            let cell = UITableViewCell()
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
            let user = searchedUserDataArray[indexPath.row]
            cell.nameLabel.text = "\(user.name)(\(user.age))"
            cell.phoneNumberLabel.text = user.phoneNumber
//            print(user)
//            print(cell)
            return cell
            
        } else {
            print("isFiterning off")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
            guard let user = userData?[indexPath.row] else { return UITableViewCell() }
            
            cell.nameLabel.text = "\(user.name)(\(user.age))"
            cell.phoneNumberLabel.text = user.phoneNumber
//            print(cell)
            return cell
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

// MARK: - Search
//extension PhoneBookViewController: UISearchBarDelegate {
//    
//}

extension PhoneBookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        for i in 0...userData!.count - 1 {
            if userData?[i].name == text {
                searchedUserDataArray.append(userData![i])
                isFiltering = true
                self.tableView.reloadData()

            }
        }
    }
}


