import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    // MARK: IBOutlets

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Private properties
    
    private var currentLocation: CLLocation?
    private var locationManager = CLLocationManager()
    private let mapManager = LocationManager()
    private let annotationIdentifier = "annotationIdentifier"
    
    // MARK: Public properties
    
    var events = [Event]()
    var annotations: [MKAnnotation]?

    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupEventMarks(mapView: mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Private Methods
    
    private func setupEventMarks(mapView: MKMapView) {
        for event in events {
            guard let location = event.venue?.city else {return}
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return }
                
                guard let placemarks = placemarks else {return}
                for placemark in placemarks {
                    
                    let annotations = MKPointAnnotation()
                    guard let city = event.venue?.city, let name = event.venue?.name else {return}
                    annotations.title = String(city + ", " + name)
                    annotations.subtitle = event.welcomeDescription
                    annotations.coordinate = placemark.location!.coordinate
                    
                    guard let placemarkLocation = placemark.location else {return}
                    
                    annotations.coordinate = placemarkLocation.coordinate
                    mapView.selectAnnotation(annotations, animated: true)
                    mapView.addAnnotations([annotations])
                    mapView.setCenter(mapView.centerCoordinate, animated: false)
                    mapView.showAnnotations([annotations], animated: true)
                    self.annotations = [annotations]
                }
            }
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

        self.annotations?.append(annotation)
        return annotationView
    }
}
