//
//  ViewController.swift
//  YelpApp
//
//  Created by Bell on 2022-06-28.
//

import UIKit

protocol BusinessView: AnyObject{
    func onBusinessRetrieval(businessList: [Business])
}

class BusinessViewController: UITableViewController {
    
    // MARK: - Properties
    var presenter: ViewPresenter!
    var businesses: [Business] = []
    var selectedIndex: IndexPath?
    var safeArea: UILayoutGuide!
    
    fileprivate let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Search by name", "Search by location"])
//        sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 18)], for: .normal)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        safeArea = view.layoutMarginsGuide
        let presenter = ViewPresenter(view: self)
        self.presenter = presenter
        self.setupNavBar()
        self.setupUI()
//        view.backgroundColor = ColorManager.lightGreenColor
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "businessCell")
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    //MARK: Table View code
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if businesses.count == 0 {
            tableView.setEmptyView(title: "No Businesses Available")
        }
        else {
            tableView.restore()
        }

        return businesses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let selectedIndex = selectedIndex else {
            return 60
        }
        
        if selectedIndex == indexPath {return 120}
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        tableView.beginUpdates()
        tableView.reloadRows(at: [selectedIndex!], with: .none)
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = businesses[indexPath.row].name
//        cell.viewController = self
//        cell.station = businesses[indexPath.row]
//        cell.animate()
        return cell
    }

    
    
    // MARK: - UI Setup
    
    func setupUI() {
//        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalToConstant: 100).isActive = true;
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        
        
        tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true

    }
    
    func setupNavBar() {
        navigationItem.title = "Businesses"
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = ColorManager.creamColor
//        appearance.titleTextAttributes = [.foregroundColor: ColorManager.lightGreenColor]
//        appearance.largeTitleTextAttributes = [.foregroundColor: ColorManager.lightGreenColor]
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}

// MARK: - View Protocol
extension BusinessViewController: BusinessView {
    
    func onBusinessRetrieval(businessList: [Business]) {
        print("View recieves the result from the Presenter.")
        self.businesses = businessList

        self.tableView.reloadData()
    }
    
//    func onShowStationStops(station: Station) {
//        self.navigationController?.pushViewController(StopsTableViewController(station: station), animated: true)
//    }

}

extension UITableView {
    
    func setEmptyView(title: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        emptyView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.text = title

        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}



