//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by makramia on 10/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit

class StudentLocationTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var studentLocations = StudentDataArray.shared.usersDataArray

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.topItem?.title = "On The Map"
        
        let refreshImage = UIImage(named: "refresh")?.withRenderingMode(.alwaysOriginal)
        let addPin = UIImage(named: "addPin")?.withRenderingMode(.alwaysOriginal)
        
        let refreshButton = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(refreshLocationData(_:)))
        
        let addLocationButton = UIBarButtonItem(image: addPin, style: .plain, target: self, action: #selector(postLocation(_:)))
        
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(_:)))
        
        navigationItem.rightBarButtonItems = [addLocationButton , refreshButton]
        
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocation()
        
    }
    
    // MARK: refreshLocationData
    
    @objc func refreshLocationData(_ sender: UIBarButtonItem) {
        getStudentLocation()
    }
    
    
    // MARK: getStudentLocation
    
    func getStudentLocation(){
        
        self.studentLocations.removeAll()
        self.startActivityIndicator(.gray)
        
        ParseClient.sharedInstance().getAllStudentsData { (success, usersData, errorString) in
            
            if success {
               
                self.studentLocations = usersData as! [StudentLocation]
                
                self.stopActivityIndicator()
                
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
                
                
            }else {
                
                self.stopActivityIndicator()
                self.presentAlertWithTitle(title: "Alert", message: errorString!, options: "OK", completion: { (option) in
                    print("option: \(option)")})
                print("There was an error with your request: \(errorString!)")
            }
        }
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

    }


        
extension StudentLocationTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let location = studentLocations[(indexPath as NSIndexPath).row]
        
        if let first = location!.firstName{
            if let last = location!.lastName {
                
                 
                    cell.textLabel?.text = "\(first) \(last)"
                cell.detailTextLabel?.text = location!.mediaURL
                    cell.imageView?.image = UIImage(named: "pin")
                    cell.imageView?.contentMode = .scaleToFill
                
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let location = studentLocations[(indexPath as NSIndexPath).row]
        
        if let studentUrl = location!.mediaURL{
           
            if let url = URL(string: studentUrl), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}
