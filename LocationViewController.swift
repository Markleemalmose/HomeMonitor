//
//  LocationViewController.swift
//  HomeMonitor
//
//  Created by Mark Lee Malmose on 29/10/15.
//  Copyright © 2015 Mark Lee Malmose. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        initializeMapView()
    }
    
    func initializeMapView() {
        mapView.showsUserLocation = true
        mapView.mapType = .Hybrid
        mapView.setUserTrackingMode(.Follow, animated: true)
        mapView.camera.heading = 20
        
        var dTUBoundaryCoordinates = [
            CLLocationCoordinate2D(latitude: 55.732885, longitude: 12.394413),
            CLLocationCoordinate2D(latitude: 55.731374, longitude: 12.401397),
            CLLocationCoordinate2D(latitude: 55.730070, longitude: 12.400668),
            CLLocationCoordinate2D(latitude: 55.731767, longitude: 12.393437)
        ]
        let boundaryPolygon = MKPolygon(coordinates: &dTUBoundaryCoordinates, count: dTUBoundaryCoordinates.count)
            mapView.addOverlay(boundaryPolygon)

    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKindOfClass(MKPolygon) {
            let polygon = overlay
            let polygonRenderer = MKPolygonRenderer(overlay: polygon)
            polygonRenderer.strokeColor = UIColor(red: 0.008, green: 0.165, blue: 0.533, alpha: 1.0)
            polygonRenderer.lineWidth = 2.0
            return polygonRenderer
        }
        
        return MKOverlayRenderer()
    }
}
