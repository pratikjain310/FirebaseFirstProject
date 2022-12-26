//
//  MapKitViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 26/12/2022.
//

import UIKit
import MapKit

struct Offices{
    var lat : Double
    var long : Double
    var name : String
    
}
class MapKitViewController: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    var office: [Offices] = [
        Offices(lat: 18.5204, long: 73.8567, name: "Pune"),
        Offices(lat: 19.0760, long: 72.8777, name: "Mumbai"),
        Offices(lat: 27.0238, long: 74.2179, name: "Rajasthan"),
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        addAnnotationsOnMaps()
    }
    
    func addAnnotationsOnMaps(){
        for place in office{
            let annot = MKPointAnnotation()
            annot.coordinate.latitude = place.lat
            annot.coordinate.longitude = place.long
            annot.title = place.name
            myMapView.addAnnotation(annot)
        }
    }
}
