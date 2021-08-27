import Foundation
import MapKit

final class LocationManager {
    // MARK: Constants
    
    private enum Const {
        static let regionInMeters: CLLocationDistance = 1000.00
    }
    
    // MARK:  Properties
    
    private let locationManager = CLLocationManager()
    
    // MARK:  Methods
    
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
