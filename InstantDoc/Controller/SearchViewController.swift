//
//  SearchViewController.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 11/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var documents: [DocumentSnapshot] = []
    public var tasks: [Result] = []
    private var listener : ListenerRegistration!
    var results = [Result]()
    var filteredResults = [Result]()
    var searchDetailVC: SearchDetailsViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Doctors, specialities, clinics, hospitals"

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = false
        
        searchController.searchBar.scopeButtonTitles = ["All", "Doctor", "Hospital"]
        searchController.searchBar.delegate = self
        
        self.query = baseQuery()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.listener.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.listener =  query?.addSnapshotListener { (documents, error) in
            guard let snapshot = documents else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let results = snapshot.documents.map { (document) -> Result in
                if let task = Result(dictionary: document.data(), id: document.documentID) {
                    return task
                } else {
                    fatalError("Unable to initialize type \(Result.self) with dictionary \(document.data())")
                }
            }
            
            self.tasks = results
            self.results = self.tasks
            self.documents = snapshot.documents
            self.tableView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func baseQuery() -> Query {
        return Firestore.firestore().collection("results").limit(to: 10)
    }
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
            }
        }
    }
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredResults = results.filter({( result : Result) -> Bool in
            let doesCategoryMatch = (scope == "All") || (result.category == scope)
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && result.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredResults.count
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultTableViewCell
        let result: Result
        if isFiltering() {
            result = filteredResults[indexPath.row]
        } else {
            result = results[indexPath.row]
        }
        cell.headingLabel.text = result.name
        cell.subHeadingLabel.text = result.desc
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let result: Result
            if isFiltering() {
                result = filteredResults[indexPath.row]
            } else {
                result = results[indexPath.row]
            }
            var showDetailsVC = SearchDetailsViewController()
            showDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "showDetailsVC") as! SearchDetailsViewController
            
            showDetailsVC.displayLabel = result.name
            showDetailsVC.qualLabel = result.desc
            showDetailsVC.specialityLabel = result.desc
            
            self.navigationController?.pushViewController(showDetailsVC, animated: true)
        }
    }
    
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }

}

extension SearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
extension SearchViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}
