import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Private properties
    
    private var locationManager: CLLocationManager?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    private var currentLocation: CLLocation?
    
    // MARK: Static properties
    
    static var events = [Event]()
    static var shered: MapViewController {
        let instance = MapViewController(events: events)
        return instance
    }
    
    // MARK: Initialaser
    
    private init(events: [Event]) {
        super.init(nibName: nil, bundle: nil)
        MapViewController.events = events
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showEvents(events: MapViewController.events)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
    }
    
    private func showEvents(events: [Event]) {
        mapManager.setupEventMarks(events: events, mapView: mapView)
    }
}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
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
}

