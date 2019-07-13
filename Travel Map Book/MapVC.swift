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
import CoreData

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var txtPlaceName: UITextField!
    @IBOutlet weak var myMap: MKMapView!
    var locationManager = CLLocationManager()
    var requestCLLocation = CLLocation()
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Çok pil harcar
        locationManager.requestWhenInUseAuthorization() //gerekli kullanımda takip eder
        locationManager.startUpdatingLocation()
        
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.chooseLocation(gesturRecognizer:)))
        recognizer.minimumPressDuration = 2
        myMap.addGestureRecognizer(recognizer)
        
        if selectedTitle != ""{
            
            let annatation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: self.selectedLatitude, longitude: self.selectedLongitude)
            annatation.coordinate = coordinate
            annatation.title = self.selectedTitle
            annatation.subtitle = self.selectedSubtitle
            self.myMap.addAnnotation(annatation)
            
            txtPlaceName.text = self.selectedTitle
            txtComment.text = self.selectedSubtitle
            
        }
        
    }
    
    @IBAction func buttonSaveClick(_ sender: Any) {
        if selectedTitle == "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
            
            newPlace.setValue(txtPlaceName.text, forKey: "title")
            newPlace.setValue(txtComment.text, forKey: "subtitle")
            newPlace.setValue(choosenLatitude, forKey: "latitude")
            newPlace.setValue(choosenLongitude, forKey: "longitude")
            
            do {
                try context.save()
                print("Saved")
            } catch  {
                print("Error")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPlace"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }
        if selectedTitle != "" {
            print("Aynı isimli konum var.")
            let alert = UIAlertController(title: "Var olan konum", message: "Konum'a kayıtlı bir kayıt bulunuyor. Tekrar Kaydedilemez.", preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: {
                (UIAlertAction) in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "geriDönme"), object: nil)
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(okButton)
            self.present(alert , animated: true, completion: nil)
    
        }
    
    }
    
    @IBAction func btnSave(_ sender: Any) {
  
    
    }
    
    @objc func chooseLocation(gesturRecognizer: UILongPressGestureRecognizer){
        //burda pin yaratma işlemi yaparız ve bunun adı anotation denir.
        
        if gesturRecognizer.state == UIGestureRecognizerState.began{
            let touchPoint = gesturRecognizer.location(in: self.myMap)
            let choosenCoordinates = self.myMap.convert(touchPoint, toCoordinateFrom: self.myMap)
            choosenLatitude = choosenCoordinates.latitude
            choosenLongitude = choosenCoordinates.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = choosenCoordinates
            annotation.title = txtPlaceName.text
            annotation.subtitle = txtComment.text
            self.myMap.addAnnotation(annotation)
            
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: location, span: span)
        myMap.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let reUserID =  "myAnnatation"
        var pinView = myMap.dequeueReusableAnnotationView(withIdentifier: reUserID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reUserID)
            pinView?.canShowCallout = true //Button oluşturma
            pinView?.pinTintColor = UIColor.orange //renk değiştirme
            
            let button = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else{
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if selectedLatitude != 0{
            if selectedLongitude != 0 {
                self.requestCLLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
                
            }
        }
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemark = placemarks{
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.selectedTitle
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
        
        
    }
    
    
}

