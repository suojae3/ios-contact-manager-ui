
import UIKit

// MARK: - PhoneBookViewController Init & Deinit
final class PhoneBookViewController: UIViewController {
    
    var filteredArr: [String] = []
    var filteredIdx: [Int] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    var userData: [User]? = nil
    let tableView = UITableView()
    weak var coordinator: RegisterUserInfoDelegate?
    
    deinit { print("PhoneBookViewController has been deinit!!") }
}

// MARK: - LifeCycle
extension PhoneBookViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.scopeButtonTitles = ["이름", "나이", "전화번호"]
        self.navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
        
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
        if isFiltering {
            return filteredIdx.count
        } else {
            return userData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFiltering {
            print("isFiltering: \(isFiltering)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
            cell.nameLabel?.text = "\(nameIndexing[filteredIdx[indexPath.row]])(\(ageIndexing[filteredIdx[indexPath.row]]))"
            cell.phoneNumberLabel?.text = phoneNumIndexing[filteredIdx[indexPath.row]]
            return cell
        } else {
            print("isFiltering: \(isFiltering)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.reuseID, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
            guard let user = userData?[indexPath.row] else { return UITableViewCell() }
            
            cell.nameLabel.text = "\(user.name)(\(user.age))"
            cell.phoneNumberLabel.text = user.phoneNumber
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
extension PhoneBookViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredArr = []
        filteredIdx = []
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        //        self.filteredArr = nameIndexing.filter{ $0.lowercased().contains(text) }
        
        for i in 0...nameIndexing.count - 1 {
            if nameIndexing[i].contains(text) {
                filteredArr.append(nameIndexing[i])
                filteredIdx.append(i)
            }
        }
        print(isFiltering)
        print(filteredArr)
        print(filteredIdx)
        dump(searchController.searchBar.text)
        self.tableView.reloadData()
    }
}
