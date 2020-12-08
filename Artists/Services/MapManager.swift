//
//  MapManager.swift
//  Artists
//
//  Created by kris on 24/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import Foundation
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    private var placeCoordinate: CLLocationCoordinate2D?
    private let regionInMeters = 1000.00
    
    func setupEventMark(event: Event, mapView: MKMapView) {

        guard let location = event.venue?.city else {return}
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = event.venue?.city
            annotation.subtitle = event.venue?.name
            
            guard let placemarkLocation = placemark?.location else {return}
            
            annotation.coordinate = placemarkLocation.coordinate
            self.placeCoordinate = placemarkLocation.coordinate
            
            mapView.selectAnnotation(annotation, animated: true)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    func showUserLocation(mapView: MKMapView) {
           if let location = locationManager.location?.coordinate {
                      let region = MKCoordinateRegion.init(center: location,
                                                           latitudinalMeters: regionInMeters,
                                                           longitudinalMeters: regionInMeters)
                      mapView.setRegion(region, animated: true)
           }
       }
    
    // Определение центра отображаемой области карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
           
           let latitude = mapView.centerCoordinate.latitude
           let longitude = mapView.centerCoordinate.longitude
           
           return CLLocation(latitude: latitude, longitude: longitude)
       }
    
    
}
