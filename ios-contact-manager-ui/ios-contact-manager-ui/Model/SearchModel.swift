//
//  SearchModel.swift
//  ios-contact-manager-ui
//
//  Created by 이보한 on 2024/1/19.
//

//import UIKit
//
//class SearchModel: UIViewController {
//    var searchResultArray = ["a", "b"]
//    
//    
//}
//
//extension SearchModel: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        func updateSearchResults(for searchController: UISearchController) {
//           print("updateSearchResults")
//            dump(searchController.searchBar.text)
//        }
//    }
//}
//
//extension SearchModel: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.searchResultArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = self.searchResultArray[indexPath.row]
//        return cell
//    }
//}
//
//extension SearchModel: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        updateSearchResults(for: self)
//    }
//}
