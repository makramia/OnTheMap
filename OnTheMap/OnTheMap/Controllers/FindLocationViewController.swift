//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by makramia on 15/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FindLocationViewController: UIViewController {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findLocationButton: BorderedButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var debugTextLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    
    var coordinate: CLLocationCoordinate2D?
    
    lazy var geocoder = CLGeocoder()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        mapView.delegate = self
        
        
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: UIButton) {
       
        if(findLocationButton.titleLabel!.text != "Submit"){
        
        guard let locationString = locationTextField.text else { return }
        
        
        // Geocode Address String
        geocoder.geocodeAddressString(locationString) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
            
            
            }
        
        // Update View
        findLocationButton.isEnabled = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
            
        } else{
           
            print("submit new studet location")
            
            // if objectId == nil, call addStudentLocation()
            if ParseClient.sharedInstance().objectId == nil {
                addStudentLocation()
            }else {
                // if objectId != nil , call updateStudentLocation()
                updateStudentLocation()
                
            }
        }
    }
    
    func addStudentLocation(){
        
        if let userName = UdacityClient.sharedInstance().userName {
        
            var components = userName.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                let mapString = locationTextField.text!
                let mediaURL = linkTextField.text!
                
                let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().userID!)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate!.latitude), \"longitude\": \(coordinate!.longitude)}"
                
                
                ParseClient.sharedInstance().postUserLocation(jsonBody: jsonBody) { (success, errorString) in
                        
                    if success {
                        
                        
                        performUIUpdatesOnMain {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else {
                        
                        print("there was an error \(errorString!)")
                        self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                            print("option: \(option)")})
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func updateStudentLocation(){
        
       if let userName = UdacityClient.sharedInstance().userName {
            var components = userName.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                let mapString = locationTextField.text!
                let mediaURL = linkTextField.text!
                
                let jsonBody = "{\"uniqueKey\": \"\(UdacityClient.sharedInstance().userID!)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(coordinate!.latitude), \"longitude\": \(coordinate!.longitude)}"
                
                
                ParseClient.sharedInstance().putUserLocation(jsonBody: jsonBody) { (success, errorString) in
                    
                    if success {
                        
                        print("putUserLocation: \(success)")
                        
                        performUIUpdatesOnMain {
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }else {
                       
                         print("there was an error \(errorString!)")
                         self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                            print("option: \(option)")})
                    }
                    
                }
            }
            
        }
        
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        findLocationButton.isEnabled = true
        
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
        
        if let error = error {
            
            self.locationTextField.isEnabled = true
            self.linkTextField.isEnabled = true
            
            print("Unable to Forward Geocode Address (\(error))")
            
            debugTextLabel.text = "Unable to Find Location for Address"
            
            self.presentAlertWithTitle(title: "Alert", message: "Unable to Forward Geocode Address (\(error))", options: "OK", completion: { (option) in
                print("option: \(option)")})
            
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            
            if let location = location {
                coordinate = location.coordinate
                debugTextLabel.text = "\(coordinate!.latitude), \(coordinate!.longitude)"
                
                self.locationTextField.isEnabled = false
                self.linkTextField.isEnabled = false
                
                self.findLocationButton.setTitle("Submit", for: .normal)
                self.findLocationButton.titleLabel?.textAlignment = .center
                
                addLocationPin(location)
                
                
                
            } else {
                
                self.locationTextField.isEnabled = true
                self.linkTextField.isEnabled = true
                
                debugTextLabel.text = "No Matching Location Found"
                self.presentAlertWithTitle(title: "Alert", message: "No Matching Location Found", options: "OK", completion: { (option) in
                    print("option: \(option)")})
                
            }
        }
        
        
        
    }
    
    
    func addLocationPin(_ location: CLLocation){
        
        
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        var annotations = [MKPointAnnotation]()
        annotation.coordinate = location.coordinate
        annotations.append(annotation)
        mapView.addAnnotations(annotations)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func configureUI() {
        
        // configure background gradient
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [UI.LoginColorTop, UI.LoginColorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        configureTextField(locationTextField)
        configureTextField(linkTextField)
        activityIndicatorView.isHidden = true
        
        
       
    }
    
    func configureTextField(_ textField: UITextField) {
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: 13.0, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        textField.backgroundColor = UI.GreyColor
        textField.textColor = UI.BlueColor
        textField.tintColor = UI.BlueColor
        textField.delegate = self
    }
}


// MARK: - LoginViewController: UITextFieldDelegate

extension FindLocationViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(locationTextField)
        resignIfFirstResponder(linkTextField)
        
    }
}


// MARK: - FindLocationViewController: MKMapViewDelegate

extension FindLocationViewController: MKMapViewDelegate {

    
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
    
}


