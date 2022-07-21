//
//  CenterMapView.swift
//  YelpApp
//
//  Created by Bell on 2022-07-21.
//

import Foundation
import MapKit

extension MKMapView{
    
    // Center map view on location with specified offset and radius
    func centerToLocation(_ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 1000, insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        
        let coordinate =  location
        let delta = CLLocationDegrees(0.003)
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)
        
        let rect = MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
        
        setVisibleMapRect(rect, edgePadding: insets, animated: true)
        
    }
    
}
