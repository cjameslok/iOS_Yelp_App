//
//  SearchViewController.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//

import Foundation
import UIKit

protocol SearchView: AnyObject{
    func onBusinessRetrieval(businessList: [Business])
}

class SearchViewController: UIViewController, UITableViewDataSource {
     
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var locationContainer: UIView!

    
    var presenter: SearchViewPresenter!
    var businesses: [Business] = []
    var selectedIndex: IndexPath?
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
            "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
            "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
            "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
            "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var safeArea: UILayoutGuide!
//    let tableView = UITableView()
//
//    let locationSearchView = LocationSearchView()
    
    fileprivate let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.blue
        return container
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let presenter = SearchViewPresenter(view: self)
        self.presenter = presenter
        presenter.viewDidLoad()
        
        safeArea = view.layoutMarginsGuide
        resultsTable.dataSource = self
        
//        toggleSearch()
 
    }
    
    
    @IBAction func onSearchClicked(_ sender: Any) {
        print("clicked")
        
        guard let location = locationTextField.text else {return}
        
        guard let term = termTextField.text else {return}
        
        
        presenter.retrieveBusinesses(location: location, term: term)
        
//        switch searchTypeControl.selectedSegmentIndex {
//        case 0:
//            presenter.retrieveBusinesses(location: locationTextField.text, term: termTextField.text)
//        case 1:
//            presenter.searchBusinessByName(nameTextField.text)
//
//        }
    }
    
    @IBAction func onSegementChanged(_ sender: UISegmentedControl) {
//        toggleSearch()
        print(sender.selectedSegmentIndex)
    }
    
//    fileprivate func toggleSearch() {
//        switch searchTypeControl.selectedSegmentIndex {
//        case 0:
//            locationContainer.isHidden = false
//            nameContainer.isHidden = true
//        case 1:
//            locationContainer.isHidden = true
//            nameContainer.isHidden = false
//        default:
//            locationContainer.isHidden = true
//            nameContainer.isHidden = true
//        }
//    }
    
    
}

extension SearchViewController: SearchView {
    
    func onBusinessRetrieval(businessList: [Business]) {
        self.businesses = businessList
        self.resultsTable.reloadData()
    }
    
}

extension SearchViewController {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = businesses[indexPath.row].name
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return businesses.count
        }
}



