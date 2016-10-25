//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterBarButtonItem: UIBarButtonItem!
    
    var businesses: [Business]!
    var filteredBusinesses: [Business]!
    var searchBar = UISearchBar()
    var isMoreDataLoading = false
    var limit = NSNumber(integerLiteral: 25)
    var offset = NSNumber(integerLiteral: 0)
    
//    var categories = [String]()
//    var sortOptions = YelpSortMode(rawValue: 0)
//    var distanceMeters = NSNumber()
//    var withDeal = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        self.navigationItem.titleView = self.searchBar
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
            }
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredBusinesses != nil) {
            return filteredBusinesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({(dataString: Business) -> Bool in
            return dataString.name?.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredBusinesses = businesses
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let categories = filters["categories"] as? [String]
        let sortOptions = YelpSortMode(rawValue: Int(filters["sort"] as! String)!)
        let distanceMeters = NSNumber(integerLiteral: Int(filters["distance"] as! String)!)
        let withDeal = filters["deal"] as? Bool
        
//        categories = (filters["categories"] as? [String]!)!
//        sortOptions = YelpSortMode(rawValue: Int(filters["sort"] as! String)!)
//        distanceMeters = NSNumber(integerLiteral: Int(filters["distance"] as! String)!)
//        withDeal = (filters["deal"] as? Bool)!
        
//        loadMoreData()
        offset = NSNumber(integerLiteral: Int(offset) + Int(limit))
        Business.searchWithTerm(term: "Restaurants", limit: limit, offset: offset, distanceMeters: distanceMeters, sort: sortOptions, categories: categories, deals: withDeal) { (businesses: [Business]?, error: Error?) -> Void in
            self.isMoreDataLoading = false
            self.filteredBusinesses = businesses
            self.tableView.reloadData()
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("hola")
//        if (!isMoreDataLoading) {
//            // Calculate the position of one screen length before the bottom of the results
//            let scrollViewContentHeight = tableView.contentSize.height
//            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
//            
//            // When the user has scrolled past the threshold, start requesting
//            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
//                isMoreDataLoading = true
//                loadMoreData()
//            }
//        }
//    }
    
//    func loadMoreData() {
//        offset = NSNumber(integerLiteral: Int(offset) + Int(limit))
//        Business.searchWithTerm(term: "Restaurants", limit: limit, offset: offset, distanceMeters: distanceMeters, sort: sortOptions, categories: categories, deals: withDeal) { (businesses: [Business]?, error: Error?) -> Void in
//            self.isMoreDataLoading = false
//            self.filteredBusinesses = businesses
//            self.tableView.reloadData()
//        }
//      
//    }
    
}
