//
//  BuisinessMapAnnotation.swift
//  YelpApp
//
//  Created by Bell on 2022-07-08.
//

import Foundation

import MapKit

class BusinessMapAnnotation: NSObject, MKAnnotation {
    var title: String?
    var business: Business?
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
      return nil
    }

  init(business: Business?) {
      self.business = business
//      self.title = business?.name
      if let coordinates = business!.coordinates {
          self.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
      } else {
          self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
      }
      super.init()
    
  }
    

}
