//
//  BuisinessMapAnnotation.swift
//  YelpApp
//
//  Created by Bell on 2022-07-08.
//

import Foundation
import Contacts
import MapKit

class BusinessMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var business: Business?
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
        return nil
    }
    
    var mapItem: MKMapItem?
    
    init(business: Business?) {
        self.business = business
        //      self.title = business?.name
        if let coordinates = business!.coordinates {
            self.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude!, longitude: coordinates.longitude!)
        } else {
            self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        let addressDict = [CNPostalAddressStreetKey: business?.name]
        let placemark = MKPlacemark(
            coordinate: self.coordinate,
            addressDictionary: addressDict as [String : Any])
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = business?.name
        self.mapItem = mapItem
        
        super.init()
        
    }
    
    
}
