//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by makramia on 08/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StudentLocationMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapkitView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation(latitude: 26.20, longitude: 50.19)
    
    
    
    var studentLocations = StudentDataArray.shared.usersDataArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.topItem?.title = "On The Map"
        
        let refreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal)
        let addPin = UIImage(named: "addPin")?.withRenderingMode(.alwaysOriginal)

        let refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(refreshLocationData(_:)))
        
        let addLocationButton = UIBarButtonItem(image: addPin, style: .plain, target: self, action: #selector(postLocation(_:)))
        
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(_:)))
        
        navigationItem.rightBarButtonItems = [addLocationButton , refreshButton]
        
        navigationItem.leftBarButtonItem = logoutButton
        
        mapkitView.delegate = self
        mapkitView.showsUserLocation = true
        
        locationManager.requestWhenInUseAuthorization()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getStudentLocation()
        
        
        
    }
    
    // MARK: refreshLocationData
    
     @objc func refreshLocationData(_ sender: UIBarButtonItem) {
      getStudentLocation()
    }
    
    // MARK: logOut
    
    @objc func logOut(_ sender: UIBarButtonItem) {
        
        print("You are about to logout")
        self.startActivityIndicator(.gray)
        
        UdacityClient.sharedInstance().deleteSession { (success, sessionID, errorString) in
            
            DispatchQueue.main.async {
                if success {
                    self.stopActivityIndicator()
                    self.dismiss(animated: true, completion: nil)
                    
                }else {
                    
                    self.stopActivityIndicator()
                    print("The Udacity Api returned an error. \(errorString!)")
                    self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                        print("option: \(option)")})
                }
            }
            
        }
        
    }
        
   
    // MARK: postLocation
    
    @objc func postLocation(_ sender: UIBarButtonItem) {
        
        ParseClient.sharedInstance().getuserDataByUniqueKey { (success, objectID, errorString) in
            
            if success {
                
                // if objectID == nil then allow user to post location
                if objectID == nil {
                    
                    performUIUpdatesOnMain {
                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "FindLocation") as! FindLocationViewController
                        self.present(controller, animated: true, completion: nil)
                    }
                    
                    
                }else {
                    
                    // if objectID != nill the ask user if he wants overwrite or not
                    
                    
                    self.presentAlertWithTitle(title: "", message: "User \(UdacityClient.sharedInstance().userName!) Has Already Posted a Student Location. Whould you Like to Overwrite Location?", options: "Overwrite", "Cancel", completion: { (option) in
                        print("option: \(option)")
                        switch(option) {
                        case 0:
                            print("option one: Overwrite")
                            
                            performUIUpdatesOnMain {
                                let controller = self.storyboard!.instantiateViewController(withIdentifier: "FindLocation") as! FindLocationViewController
                                self.present(controller, animated: true, completion: nil)
                            }
                            
                            break
                        case 1:
                            print("option two: Cancel")
                        default:
                            break
                        }
                    })
                    
                }
                
                
            }else {
                self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                    print("option: \(option)")})
            }
        }
        
    }
    
    
    // MARK: getStudentLocation
    func getStudentLocation(){
        
        self.studentLocations.removeAll()
        
        self.startActivityIndicator(.gray)
        
        ParseClient.sharedInstance().getAllStudentsData { (success, usersData, errorString) in
            
            if success {
                
                self.studentLocations = usersData as! [StudentLocation]
                
                //print(self.studentLocations)
                
                self.stopActivityIndicator()
                
                performUIUpdatesOnMain {
                    self.loadStudentsLocations()
                    
                }
                
                
               
            }else {
               
                self.stopActivityIndicator()
                
                self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                    print("option: \(option)")})
                
                print("There was an error with your request: \(errorString!)")
            }
        }
    }


    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        currentLocation = locationManager.location!
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            
            let calloutButton = UIButton(type: .infoLight)
            annotationView!.rightCalloutAccessoryView = calloutButton
            annotationView!.sizeToFit()
            
            
        }
        else {
            annotationView!.annotation = annotation
        }
        
        
        
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let studentUrl = view.annotation?.subtitle{
                if let url = URL(string: studentUrl!), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            
            
        }
        
    }
    
    func loadStudentsLocations() {
        
        mapkitView.removeAnnotations(mapkitView.annotations)
        let locations = studentLocations
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            
            let latitude = CLLocationDegrees((location!.latitude) ?? 0)
            let longitude = CLLocationDegrees(location!.longitude ?? 0)
            
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            if let first = location!.firstName{
                if let last = location!.lastName {
                    if let mediaURL = location!.mediaURL{
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                    }
                }
            }
            
           
            
            
            
        }
        
        self.mapkitView.addAnnotations(annotations)
        
    }
    
    
   
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
}





