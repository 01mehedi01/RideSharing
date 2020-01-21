//
//  ReaderVC.swift
//  Cloude
//
//  Created by Mehedi Hasan on 17/1/20.
//  Copyright © 2020 Mehedi Hasan. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation


class ReaderVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cancleUbarbtn: UIButton!
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var uberHasBeenCalled = false
    
    var reff = DatabaseReference()
    let userID =  Auth.auth().currentUser?.uid
    var driverLocation = CLLocationCoordinate2D()
    
    
    var driverOnTheWay = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        reff = Database.database().reference()
        
        
        
        locationManager.delegate = self 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        if let email =  Auth.auth().currentUser?.email {
           
             reff.child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                
                self.uberHasBeenCalled = true
                self.cancleUbarbtn.setTitle("Cancel Uber", for: .normal)
                self.reff.child("RideRequests").removeAllObservers()
                
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                        if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                            self.driverOnTheWay = true
                            self.displayDriverAndRider()
                            
                            if let email = Auth.auth().currentUser?.email { self.reff.child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childChanged, with: { (snapshot) in
                                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                                    if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                                        if let driverLon = rideRequestDictionary["driverLon"] as? Double {
                                            self.driverLocation = CLLocationCoordinate2D(latitude: driverLat, longitude: driverLon)
                                            self.driverOnTheWay = true
                                            self.displayDriverAndRider()
                                        }
                                    }
                                }
                            })
                            }
                        }
                    }
                }
            })
        }
       
        
    }
    
    
    func displayDriverAndRider() {
        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
        let riderCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
        let roundedDistance = round(distance * 100) / 100
        cancleUbarbtn.setTitle("Your driver is \(roundedDistance)km away!", for: .normal)
        mapView.removeAnnotations(mapView.annotations)
        
        let latDelta = abs(driverLocation.latitude - userLocation.latitude) * 2 + 0.005
        let lonDelta = abs(driverLocation.longitude - userLocation.longitude) * 2 + 0.005
        
        let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
        mapView.setRegion(region, animated: true)
        
        let riderAnno = MKPointAnnotation()
        riderAnno.coordinate = userLocation
        riderAnno.title = "Your Location"
        mapView.addAnnotation(riderAnno)
        
        let driverAnno = MKPointAnnotation()
        driverAnno.coordinate = driverLocation
        driverAnno.title = "Your Driver"
        mapView.addAnnotation(driverAnno)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
       
        if let coord = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            
            
            if uberHasBeenCalled {
                displayDriverAndRider()
                
            } else {
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
                mapView.removeAnnotations(mapView.annotations)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.title = "Your Location"
                mapView.addAnnotation(annotation)
            }
        }
        
    }
   
    @IBAction func LogoutPress(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CallAnUbarBtnPress(_ sender: Any) {
        
        if !driverOnTheWay {
        
        if let email = Auth.auth().currentUser?.email {
            
            print("email = > \(email)")
            
            if uberHasBeenCalled {
                uberHasBeenCalled = false
                cancleUbarbtn.setTitle("Call an Uber", for: .normal)
                
                reff.child("RideRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (snapshot) in
                    snapshot.ref.removeValue()
                    self.reff.child("RideRequests").removeAllObservers()
                })
            } else {
                let rideRequestDictionary : [String:Any] = ["email":email,"lat":userLocation.latitude,"lon":userLocation.longitude]
                
                reff.child("RideRequests").childByAutoId().setValue(rideRequestDictionary)
                uberHasBeenCalled = true
                cancleUbarbtn.setTitle("Cancel Uber", for: .normal)
            }
            
            
        }
      }
    }
}
