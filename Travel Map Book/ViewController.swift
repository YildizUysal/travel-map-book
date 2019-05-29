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
        
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.chooseLocation(gesturRecognizer:)))
        recognizer.minimumPressDuration = 3
        myMap.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gesturRecognizer: UILongPressGestureRecognizer){
        //burda pin yaratma işlemi yaparız ve bunun adı anotation denir.
        
        if gesturRecognizer.state == UIGestureRecognizerState.began{
            let touchPoint = gesturRecognizer.location(in: self.myMap)
            let choosenCoordinates = self.myMap.convert(touchPoint, toCoordinateFrom: self.myMap)
            let annotation = MKPointAnnotation()
            annotation.coordinate = choosenCoordinates
            annotation.title = "New Annatation"
            annotation.subtitle = "Favorite Place"
            self.myMap.addAnnotation(annotation)
            
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        myMap.setRegion(region, animated: true)
    }
    

}

