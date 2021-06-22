import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager: CLLocationManager?
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    private var currentLocation: CLLocation?
    
    private var test: Int?
    static var events = [Event]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        print("3333")
        super.init(nibName: nil, bundle: nil)
    }
    
    init(events: [Event]) {
        MapViewController.events = events
        self.test = 5
        print("11111111")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(MapViewController.events)
        print("222222222")
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
        }
    }
    
    func showEvents(events: [Event]) {
        mapManager.setupEventMarks(events: events, mapView: mapView)
    }
}

extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Show User location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        showEvents(events: MapViewController.events)
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
        renderer.lineWidth = 7
        
        return renderer
    }
}

