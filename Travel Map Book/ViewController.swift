//
//  ViewController.swift
//  Travel Map Book
//
//  Created by Yıldız Uysal on 26.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var myMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        
    }
    
    

}

