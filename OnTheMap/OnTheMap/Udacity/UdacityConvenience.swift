//
//  Convenience.swift
//  OnTheMap
//
//  Created by makramia on 05/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
   
    func authenticateWithViewController(_ hostViewController: UIViewController, jsonBody: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlersvarr each request so that they run one after the other
        
        
        
        self.getSession(jsonBody: jsonBody) { (success, sessionID,userID, errorString) in
            
            if success {
                
                // success! we have the sessionID!
                self.sessionID = sessionID
                self.userID = userID
                
                
                self.getPublicDataForUserID(userID: userID) { (success, userName, errorString) in
                    
                    if success {
                        print("user name is: \(userName!)")
                        
                        if let userName = userName {
                            self.userName = "\(userName)"
                        }
                        
                        
                    }
                    
                    completionHandlerForAuth(success, errorString)
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
        
        
        
        
    }
    
    
    
    
    private func getSession( jsonBody: String, completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?,_ userID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        _ = taskForPOSTMethod(UdacityClient.Methods.AuthenticationSession,jsonBody: jsonBody) { (result, error) in
            
            
            if let error = error {
                completionHandlerForSession(false ,nil ,nil,"\(error.localizedDescription) ")
            }else {
                
                 let newResult = result as! [String:AnyObject]
                    
                
                if let sessionID = newResult[UdacityClient.JSONResponseKeys.Session]![UdacityClient.JSONResponseKeys.SessionID] as? String  , let userID = newResult[UdacityClient.JSONResponseKeys.Account]![UdacityClient.JSONResponseKeys.UserID] as? String{
                    
                    completionHandlerForSession(true ,sessionID, userID, nil)
                } else {
                     completionHandlerForSession(false ,nil ,nil," \(error!.localizedDescription)")
                }
                                
            }
        }
        
    }
    
    func deleteSession(_ completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        
        
        _ = taskForDeleteMethod(UdacityClient.Methods.AuthenticationSession, completionHandlerForDelete: { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,nil,"\(error.localizedDescription) ")
            }else {
                let newResult = result as! [String:AnyObject]
                 if let sessionID = newResult[UdacityClient.JSONResponseKeys.Session]![UdacityClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForSession(true ,sessionID ,nil)
                    
                }else {
                    completionHandlerForSession(false ,nil ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        )
    }
    
    private func getPublicDataForUserID(userID: String?,_ completionHandlerForUserID: @escaping (_ success: Bool,_ nickname: String?, _ errorString: String?) -> Void) {
        
        
        
        
        
        var mutableMethod: String = UdacityClient.Methods.AuthenticationGetPublicDataForUserID
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        
        
        /* 2. Make the request */
        
        _ = taskForGETMethod(mutableMethod) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! [String:AnyObject]
                
                print(newResult)
                
                if let userName = newResult[UdacityClient.JSONResponseKeys.nickName] as? String  {
                    
                    completionHandlerForUserID(true ,userName,nil)
                    print("user name is: \(userName)")
                }else {
                    completionHandlerForUserID(false ,nil,"\(String(describing: error?.localizedDescription))")
                    
                }
                
                
            }
        }
        
    }
}
    


