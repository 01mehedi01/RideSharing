//
//  AcceptVC.swift
//  Cloude
//
//  Created by Mehedi Hasan on 18/1/20.
//  Copyright © 2020 Mehedi Hasan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptVC: UIViewController {

    @IBOutlet weak var mapviewAccept: MKMapView!
    
    @IBOutlet weak var acceptbtn: UIButton!
    
    
    var requestLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var requestEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapviewAccept.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requestEmail
        mapviewAccept.addAnnotation(annotation)
    }
    

    @IBAction func AcceptBtn(_ sender: Any) {
        Database.database().reference().child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: requestEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat":self.driverLocation.latitude, "driverLon":self.driverLocation.longitude])
            Database.database().reference().child("RideRequests").removeAllObservers()
        }
        
        // Give directions
        
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placemarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.requestEmail
                    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: options)
                }
            }
        }
    }
    
}
