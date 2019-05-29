//
//  ViewController.swift
//  Travel Map Book
//
//  Created by Yıldız Uysal on 26.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var myMap: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Çok pil harcar
        locationManager.requestWhenInUseAuthorization() //gerekli kullanımda takip eder
        locationManager.startUpdatingLocation() 
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        myMap.setRegion(region, animated: true)
    }
    

}

