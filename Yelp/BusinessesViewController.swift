//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import AASquaresLoading

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var refreshControl: UIRefreshControl!
    var needsRefresh: Bool = false
    var isMoreDataLoading:Bool = false
    var loadOffset: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupSearchBar()
        self.initialLoadRestaurants()
        self.showLoading(stopTime:2.0)
        self.setupRefreshControl()
        
        self.needsRefresh = true
    }
    
    private func showLoading(stopTime: TimeInterval) {
        self.view.squareLoading.start(0.0)
        self.view.squareLoading.setSquareSize(60)
        self.view.squareLoading.color = UIColor.red
        self.view.squareLoading.stop(stopTime)
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(BusinessesViewController.initialLoadRestaurants), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0)
    }
    
    func initialLoadRestaurants() {
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) in
            self.isMoreDataLoading = false
            self.businesses = businesses
            self.tableView.reloadData()
            }
        )
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        navigationItem.titleView = searchBar
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        searchBar.text = ""
        filtersViewController.delegate = self
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Business.searchWithTerm(term: searchText) { (businesses:[Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}

extension BusinessesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! BusinessTableViewCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        
        let deals = filters["deals"] as? Bool
        let distance = filters["distance"] as! YelpDistance
        let sortBy = YelpSortMode(rawValue:filters["sortBy"] as! Int)
        let categories = filters["categories"] as? [String]
        
        Business.searchWithTerm(term: "Restaurants", sort: sortBy, distance: distance, categories: categories, deals: deals) { (businesses: [Business]?, error:Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                
                isMoreDataLoading = true
                if loadOffset == nil {
                    loadOffset = 0
                }
                
                loadOffset! += businesses.count
                
                initialLoadRestaurants()
            }
        }
    }
}
