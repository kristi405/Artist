import UIKit
import MapKit
import CoreLocation

final class MapEvents: UIViewController {
   // MARK: IBOutlets
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var routeButton: UIButton!
    
    // MARK: Private Properties
    
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    private var latitude: Double?
    private var longitude: Double?
    
    // MARK: Public Properties
    
    var event: Event?
    var didUpdateUserLocation = false
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.barTintColor = R.color.color()
        routeButton.layer.cornerRadius = Constants.cornerRadius
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
        setupEventMark(mapView: mapView)
    }
    
    // MARK: Actions
    
    // Button of build a route on the map
    @IBAction private func showRote() {
        let sourceLocation = CLLocationCoordinate2D(latitude: Constants.latitude, longitude: Constants.longitude)

        if let latitudeString = event?.venue?.latitude {
            let latitudeDouble = Double(latitudeString)
            self.latitude = latitudeDouble
        }

        if let longitudeString = event?.venue?.longitude {
            let longitudeDouble = Double(longitudeString)
            self.longitude = longitudeDouble
        }

        guard let latitude = self.latitude else {return}
        guard let longitude = self.longitude else {return}
        let destinationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        showRoutOnMap(pickupCoordinate: sourceLocation, destinationCoordinate: destinationCoordinate)
    }
    
    // MARK: Private Methods
    
    private func setupEventMark(mapView: MKMapView) {
        guard let artistEvent = event else {return}
        guard let location = artistEvent.venue?.city else {return}
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks else {return}
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            guard let city = artistEvent.venue?.city, let name = artistEvent.venue?.name else {return}
            annotation.title = String(city + ", " + name)
            annotation.subtitle = artistEvent.welcomeDescription
            
            guard let placemarkLocation = placemark?.location else {return}
            
            annotation.coordinate = placemarkLocation.coordinate
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
    
    // Build route on the map
    private func showRoutOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationmItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        mapView?.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        let diractionRequest = MKDirections.Request()
        diractionRequest.source = sourceItem
        diractionRequest.destination = destinationmItem
        diractionRequest.transportType = .any
        
        let diraction = MKDirections(request: diractionRequest)
        
        diraction.calculate { (response, error) in
            guard let response = response else {
                self.showErrorAlert()
                return
            }
            let route = response.routes[0]
            
            self.mapView?.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView?.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    // Show alert if we can not build the route
    private func showErrorAlert() {
        let alert = UIAlertController(title: Constants.error, message: Constants.canNotBuildRote, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - Extensions CLLocationManager Delegate and MKMapView Delegate

extension MapEvents: CLLocationManagerDelegate, MKMapViewDelegate {
    // Show User location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }

        if currentLocation == nil {
            guard let mapView = self.mapView else {return}
            mapManager.showUserLocation(mapView: mapView)
            self.didUpdateUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            
            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    // Style of line on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = Constants.roteLineWidth
        
        return renderer
    }
}

extension MapEvents {
    // MARK: Constants
    private enum Constants {
        static let ok = "ОК"
        static let canNotBuildRote = "Невозможно построить маршрут"
        static let error = "Ошибка"
        static let cornerRadius: CGFloat = 7
        static let roteLineWidth: CGFloat = 4.0
        static let latitude: Double = 53
        static let longitude: Double = 29
    }
}

