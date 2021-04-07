import Foundation
import MapKit

final class LocationManager {
    // MARK: Constants
    
    private enum Const {
        static let regionInMeters: CLLocationDistance = 1000.00
    }
    
    // MARK:  Properties
    private let locationManager = CLLocationManager()
    private var placeCoordinate: CLLocationCoordinate2D?
    
    // set a marker on the map
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
    
    // showing the user's location on the map
    func showUserLocation(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: Const.regionInMeters,
                                                 longitudinalMeters: Const.regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Determining the center of the displayed map area
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
