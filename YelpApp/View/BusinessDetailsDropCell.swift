////
////  BusinessDetailsDropCell.swift
////  YelpApp
////
////  Created by Bell on 2022-06-29.
////
//
//import Foundation
//import UIKit
//
//class StationDetailsDropCell: UITableViewCell{
//    
//    weak var viewController: StationsView?
//    
//    
//    var station: Station? {
//        didSet {
//            guard let station = station else {return}
//            self.title.text = station.name
//            self.details.text = "Time: "
//            if (station.time != nil) {
//                self.details.text! += String(station.time!)
//            } else {
//                self.details.text! += "N/A"
//            }
//        }
//    }
//    
//    fileprivate let title: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        label.text = "Name"
//        label.textColor = ColorManager.lightGreenColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        return label
//    }()
//    
//    fileprivate let details: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        label.text =  "details"
//        label.textColor = ColorManager.creamColor
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    fileprivate let container: UIView = {
//        let v = UIView()
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.clipsToBounds = true
//        v.backgroundColor = ColorManager.creamColor
//        v.layer.cornerRadius = 5
//        
//        return v
//    }()
//    
//    fileprivate let stopsButton: UIButton = {
//        let button = UIButton()
//        button.configuration = .filled()
//        button.setTitle("View Stops", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = ColorManager.darkGreenColor
//        button.titleLabel?.textColor = ColorManager.lightGreenColor
//        
//        
//        return button
//
//    }()
//    
//    func animate() {
//        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
//            self.contentView.layoutIfNeeded()
//        })
//    }
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        stopsButton.addAction(
//          UIAction { _ in
//            print("You tapped the button!")
//              guard let station = self.station else {return}
//              self.viewController?.onShowStationStops(station: station)
//          }, for: .touchUpInside
//        )
//
//        contentView.backgroundColor = ColorManager.lightGreenColor
//        
//        contentView.addSubview(container)
//        
//        container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
//        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
//        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
//        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
//        
//        container.addSubview(title)
//        container.addSubview(details)
//        container.addSubview(stopsButton)
//        
//        title.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
//        title.leadingAnchor.constraint(equalTo: container.leadingAnchor,  constant: 4).isActive = true
//        title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
//        title.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        
//        details.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
//        details.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4).isActive = true
//        details.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4).isActive = true
//        details.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        
//        stopsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8).isActive = true
//        stopsButton.bottomAnchor.constraint(equalTo: details.bottomAnchor, constant: -20).isActive = true
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//}
