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

        guard let coordinates = business!.coordinates else {return}
        let businessLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

        annotation.coordinate = businessLocation.coordinate
        mapView.centerToLocation(businessLocation)
        mapView.addAnnotation(annotation)

        // Do any additional setup after loading the view.
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
