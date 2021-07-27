import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: Private properties
    
    private var currentLocation: CLLocation?
    private var locationManager: CLLocationManager?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    
    // MARK: Public properties
    
    var events = [Event]()
    var annotations: [MKAnnotation]?

    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapManager.setupEventMarks(events: events, mapView: mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(events)
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
        self.annotations = annotation as? [MKAnnotation]
        return annotationView
    }
}
