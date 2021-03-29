import UIKit
import MapKit
import CoreLocation

final class MapEvents: UIViewController {
    // MARK: Constants
    
    private enum Const {
        static let horizontalSpasingCancelButton: CGFloat = 340
        static let verticalSpasingCancelButton: CGFloat = 20
        static let widthCancelButton: CGFloat = 25
    }
    
    // MARK: Private Properties
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation?
    private var mapView: MKMapView?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    
    // MARK: Public Properties
    
    var event: Event!
    
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
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
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
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

