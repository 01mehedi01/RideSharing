//
//  DriverTableVC.swift
//  Cloude
//
//  Created by Mehedi Hasan on 18/1/20.
//  Copyright © 2020 Mehedi Hasan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverTableVC: UIViewController , CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var rideRequests : [DataSnapshot] = []
    var locationManager = CLLocationManager()
    var driverLocation = CLLocationCoordinate2D()
    var reff = DatabaseReference()
    
    let backgroundImageView = UIImageView()
    
    @IBOutlet weak var drivertableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        reff = Database.database().reference()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        
        reff.child("RideRequests").observe(.childAdded) { (snapshot) in
            if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                if let driverLat = rideRequestDictionary["driverLat"] as? Double {
                    
                } else {
                    self.rideRequests.append(snapshot)
                   self.drivertableview.reloadData()
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer) in
             self.drivertableview.reloadData()
        }
      
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate {
            driverLocation = coord
        }
    }

    // MARK: - Table view data source

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("rideRequests  count Size \(rideRequests.count)")
        return rideRequests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestViewCell
        
        let snapshot = rideRequests[indexPath.row]
        
        if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
            if let email = rideRequestDictionary["email"] as? String {
                if let lat = rideRequestDictionary["lat"] as? Double {
                    if let lon = rideRequestDictionary["lon"] as? Double {
                        
                        let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                        let riderCLLocation = CLLocation(latitude: lat, longitude: lon)
                        let distance = driverCLLocation.distance(from: riderCLLocation) / 1000
                        let roundedDistance = round(distance * 100) / 100
                        
                        
                        //cell.textLabel?.text = "\(email) - \(roundedDistance)km away"
                        cell.emailContainerlabel?.text = "\(email) - \(roundedDistance)km away"
                        
                    }
                }
                
                
            }
        }
        
        return cell
    }

    
 
    
    @IBAction func LogOut(_ sender: Any) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = rideRequests[indexPath.row]
        performSegue(withIdentifier: "acceptVC", sender: snapshot)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let acceptVC = segue.destination as? AcceptVC {
            if let snapshot = sender as? DataSnapshot {
                if let rideRequestDictionary = snapshot.value as? [String:AnyObject] {
                    if let email = rideRequestDictionary["email"] as? String {
                        if let lat = rideRequestDictionary["lat"] as? Double {
                            if let lon = rideRequestDictionary["lon"] as? Double {
                                acceptVC.requestEmail = email
                                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                                acceptVC.requestLocation = location
                                acceptVC.driverLocation = driverLocation
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
}
