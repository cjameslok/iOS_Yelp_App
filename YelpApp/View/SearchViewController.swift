//
//  SearchViewController.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol SearchView: AnyObject{
    func onBusinessRetrieval(businessList: [Business])
}

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
     
    @IBOutlet weak var searchTypeControl: UISegmentedControl!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var termTextField: UITextField!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var locationContainer: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var distanceSortingSelector: UICommand!
    @IBOutlet weak var ratingSortingSelector: UICommand!
    @IBOutlet weak var searchButton: UIButton!
    
    var presenter: SearchViewPresenter!
    var businesses: [Business] = []
    var selectedIndex: IndexPath?
    let locationManager = CLLocationManager()
    var isLocationMode = false

    
    fileprivate let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.blue
        return container
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setUpTableView()
        self.presenter = SearchViewPresenter(view: self)
        self.presenter.viewDidLoad()
    }

    func setupNavBar() {
        navigationItem.title = "Search Reviews"
    }
    
    func setUpTableView() {
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(UINib(nibName: "BusinessDetailsCell", bundle: nil), forCellReuseIdentifier: "BusinessDetailsCell")
    }
    
    func setupLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func sortTableByDistance(_ sender: Any) {
        
        let sortedBusinesses = businesses.sorted {
            guard let d0 = $0.distance, let d1 = $1.distance else { return false }
            return d0 < d1
        }
        self.businesses = sortedBusinesses
        resultsTableView.reloadData()
        sortButton.setTitle("by distance", for: .normal)
    }
    
    @IBAction func sortTableByRating(_ sender: Any) {
        
        let sortedBusinesses = businesses.sorted {
            guard let r0 = $0.rating, let r1 = $1.rating else { return false }
            return r0 > r1
        }
        self.businesses = sortedBusinesses
        resultsTableView.reloadData()
        sortButton.setTitle("by rating", for: .normal)

    }
    
    
    
    @IBAction func onSearchClicked(_ sender: Any) {
        sortButton.setTitle("Sort", for: .normal)
        guard let location = locationTextField.text else {return}
        guard let term = termTextField.text else {return}
        
        if(isLocationMode){
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            presenter.retrieveBusinessesByCoordinate(term: term, latitude: locValue.latitude, longitude: locValue.longitude)
        }else {
            presenter.retrieveBusinesses(location: location, term: term)
        }
        
    }

    
    @IBAction func onSegementChanged(_ sender: UISegmentedControl) {
        toggleSearch()
        print(sender.selectedSegmentIndex)
    }
    
    fileprivate func toggleSearch() {
        switch searchTypeControl.selectedSegmentIndex {
        case 0:
            isLocationMode = false
            locationTextField.isHidden = false
            searchButton.setTitle("Search", for: .normal)
        case 1:
            isLocationMode = true
            setupLocationManager()
            locationTextField.isHidden = true
            searchButton.setTitle("Search near me", for: .normal)
        default:
            locationTextField.isHidden = false
        }
    }
    
}

extension SearchViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
}

extension SearchViewController: SearchView {
    
    func onBusinessRetrieval(businessList: [Business]) {
        self.businesses = businessList
        self.resultsTableView.reloadData()
    }
    
}

extension SearchViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(BusinessDetailsViewController(business: businesses[indexPath.row] ), animated: true)    }
        
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDetailsCell", for: indexPath) as! BusinessDetailsCell
        

        cell.nameLabel.text = businesses[indexPath.row].name
        cell.priceLabel.text = businesses[indexPath.row].price
        
        if let rating = businesses[indexPath.row].rating {
            cell.rating = rating
            cell.ratingLabel.text = String(rating) + " / 5"
        }
        else {
            cell.ratingLabel.text = "N/A"
        }
        
        if let distance = businesses[indexPath.row].distance {
            cell.distanceLabel.text = String(round(distance)) + " m"
        }
        else {
            cell.ratingLabel.text = ""
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
}



