//
//  BusinessDetailsViewViewController.swift
//  YelpApp
//
//  Created by Bell on 2022-06-30.
//

import UIKit
import MapKit

class BusinessDetailsViewViewController: UIViewController {

    var business: Business?
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var address1Label: UILabel!
    @IBOutlet weak var address2Label: UILabel!
    @IBOutlet weak var address3Label: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    
    init(business: Business) {
        super.init(nibName: nil, bundle: nil)
        self.business = business
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = business?.name
        resetLabels()
        setupInfo()

        guard let coordinates = business!.coordinates else {return}
        let businessLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

        annotation.coordinate = businessLocation.coordinate
        mapView.centerToLocation(businessLocation)
        mapView.addAnnotation(annotation)

        // Do any additional setup after loading the view.
    }
    
    func setupInfo() {
//        infoView.backgroundColor = UIColor.white
        let count: Int = business!.location!.display_address!.count
        
        if count > 0 {
            if let a1 = business!.location?.display_address?[0] {
                address1Label.text = a1
            } else {
                address1Label.text = ""
            }
            if count >= 2 {
                
                if let a2 = business!.location?.display_address?[1] {
                    address2Label.text = a2
                } else {
                    address2Label.text = ""
                }
                
                if count == 3 {
                    if business!.location?.display_address?.count == 3, let a3 = business!.location?.display_address?[2] {
                        address3Label.text = a3
                    } else {
                        address3Label.text = ""
                    }
                }
            }
            
        }
        
        if let p = business!.display_phone {
            phoneLabel.text = p
        } else {
            phoneLabel.text = ""
            return
        }
        
    }
    
    func resetLabels() {
        phoneLabel.text = ""
        address1Label.text = ""
        address2Label.text = ""
        address3Label.text = ""


    }

}

private extension MKMapView{
    
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
      setRegion(coordinateRegion, animated: true)
  }
    
}
