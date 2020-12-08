//
//  MapViewController.swift
//  Artists
//
//  Created by kris on 24/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let mapManager = MapManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var marker: UIImageView!
    @IBOutlet weak var navigationButton: UIButton!
    
    @IBAction func navigationButtonTapped(_ sender: Any) {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
