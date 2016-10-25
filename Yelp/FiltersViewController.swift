//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Anastasia Blodgett on 10/22/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

enum FiltersIdentifier: String {
    case Category   = "Category"
    case SortBy     = "Sort By"
    case Distance   = "Distance"
    case Deal       = "Offering Deal"
}

enum Filters:Int {
    case Deal, Distance, SortBy, Category
}

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters:[String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let sortBy:[YelpSortMode] = [.bestMatched, .distance, .highestRated]
    var sortBySelected:Int = 0
    
    let distances:[YelpDistance] = [.auto, .walking, .close, .driving, .farAway]
    var selectedDistance: Int = 0
    
    var selectedRows = [String:NSIndexPath]()
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    var deals: Bool = false
    
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBAction func onCancelButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearchButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String: AnyObject]()
        
        //Deals
        if deals {
            filters["deals"] = deals as AnyObject?
        }
        
        //Distance
        let distance = distances[selectedDistance]
        filters["distance"] = distance as AnyObject?
        
        //SortBy
        filters["sortBy"] = sortBySelected as AnyObject?
        
        //Categories
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject?
        }
        
        delegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = YelpCategories.yelpCategories
        
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
        tableView.allowsMultipleSelection = true
        
        tableView.backgroundView?.backgroundColor = UIColor.white
    }
    
    //MARK: TableView Data Source method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return distances.count
        }
        else if section == 2 {
            return sortBy.count
        }
        else if section == 3 {
            return categories.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            cell.filterLabel.text = "Offering a Deal"
            cell.delegate = self
            cell.filterSwitch.isOn = self.deals
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "expandedCell", for: indexPath) as! ExpandedTableViewCell
            cell.expandedLabel.text = distances[indexPath.row].distanceValue
            
            return cell
        }
        else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "expandedCell", for: indexPath) as! ExpandedTableViewCell
            cell.expandedLabel.text = sortBy[indexPath.row].sortValue
            
            return cell
        }
        
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchTableViewCell
            cell.filterLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            
            cell.filterSwitch.isOn = switchStates[indexPath.row] ?? false
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func addSelectedCellWithSection(indexPath:NSIndexPath) ->NSIndexPath?
    {
        let existingIndexPath = selectedRows["\(indexPath.section)"];
        if (existingIndexPath == nil) {
            selectedRows["\(indexPath.section)"]=indexPath;
        }
        else {
            selectedRows["\(indexPath.section)"]=indexPath;
            return existingIndexPath
        }
        return nil;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.backgroundColor = UIColor.yellow
        if indexPath.section == 1 {
            self.selectedDistance = indexPath.row
        }
        else if indexPath.section == 2 {
            self.sortBySelected = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle = ""
        if section == 1 {
            sectionTitle = "Distance"
        }
        else if section == 2 {
            sectionTitle = "Sort By"
        }
        else if section == 3 {
            sectionTitle = "Category"
        }
        return NSLocalizedString(sectionTitle, comment: "")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)
        
        if indexPath?.section == 0 {
            self.deals = value
        }
        else {
            switchStates[indexPath!.row] = value
        }
    }
}
