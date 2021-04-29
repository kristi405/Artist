import UIKit
import MapKit
import CoreLocation

final class MapEvents: UIViewController {
    // MARK: Constants
    
    private enum Const {
        static let horizontalSpasingCancelButton: CGFloat = 360
        static let verticalSpasingCancelButton: CGFloat = 20
        static let widthCancelButton: CGFloat = 25
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Private Properties
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    var latitude: Double?
    var longitude: Double?
    
    // MARK: Public Properties
    
    var event: Event?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let map = MKMapView(frame: CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: self.view.frame.height))
        self.mapView = map
        guard let mapView = self.mapView else {return}
        view.addSubview(mapView)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        let sourceLocation = CLLocationCoordinate2D(latitude: 53, longitude: 29)
        
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
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
        guard let event = event else {return}
        mapManager.setupEventMark(event: event, mapView: mapView)
        setupCancelButton()
    }
    
    // MARK: IBActions
    
    @IBAction private func cancelTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK:  Private Methods
    
    // Draw cancelButton
    private func setupCancelButton() {
        let cancelButton = UIButton(frame: CGRect(x: Const.horizontalSpasingCancelButton,
                                                  y: Const.verticalSpasingCancelButton,
                                                  width: Const.widthCancelButton,
                                                  height: Const.widthCancelButton))
        
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.isHidden = false
        mapView?.addSubview(cancelButton)
    }
    
    func showRoutOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
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
        
        self.mapView?.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        let diractionRequest = MKDirections.Request()
        diractionRequest.source = sourceItem
        diractionRequest.destination = destinationmItem
        diractionRequest.transportType = .any
        
        let diraction = MKDirections(request: diractionRequest)
        
        diraction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let route = response.routes[0]
            
            self.mapView?.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView?.setRegion(MKCoordinateRegion(rect), animated: true)
        }
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
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
}

