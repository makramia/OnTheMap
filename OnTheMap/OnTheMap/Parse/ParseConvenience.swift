//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by makramia on 04/01/2019.
//  Copyright © 2019 makramia. All rights reserved.
//

import Foundation

extension ParseClient {
    
    
    func getAllStudentsData(_ completionHandlerForUserID: @escaping (_ success: Bool,_ usersData: [Any]?, _ errorString: String?) -> Void) {
        
        let parameters =  [ParseClient.ParameterKeys.Limit:ParseClient.ParameterValues.Limit,ParseClient.ParameterKeys.Order:ParseClient.ParameterValues.Order]
        
        /* 2. Make the request */
        
        _ = taskForGETMethod( ParseClient.Methods.StudentLocation, parameters: parameters as [String : AnyObject] ) { (results, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                
                if let results = results?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                    let newResult = StudentLocation.studentLocationFromResults(results)
                    completionHandlerForUserID(true , newResult, nil)
                    
                    
                }else {
                    completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    func getuserDataByUniqueKey(_ completionHandlerForUserID: @escaping (_ success: Bool,_ objectId:String?, _ errorString: String?) -> Void) {
        
        let method: String = Methods.StudentLocation
        
        let newParameterValues = substituteKeyInMethod(ParseClient.ParameterValues.Where, key: ParseClient.URLKeys.UserID, value: UdacityClient.sharedInstance().userID!)!
        
        
        let parameters =  [ParseClient.ParameterKeys.Where:newParameterValues]
        
        
        /* 2. Make the request */
        
        
        let _ = taskForGETMethod(method, parameters: parameters as [String : AnyObject]) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                
                if let results = result?[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    
                let usersData = StudentLocation.studentLocationFromResults(results)
                
                //let newResult = result as! StudentLocations
                
                   if !(usersData.isEmpty){
                   
                    
                        // if there is data (user already posted his Location)
                        // get objectId
                         let objectId = usersData[0].objectId
                         ParseClient.sharedInstance().objectId = objectId
                            
                            
                       // completionHandlerForUserID(true ,self.objectId,nil)
                        
                    
                    }
                    
                    
                    completionHandlerForUserID(true ,self.objectId,nil)
                    
                    
                    /*
                    else {
                       // completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                       //  completionHandlerForUserID(false ,nil,nil)
                         completionHandlerForUserID(true ,self.objectId,nil)
                    }*/
                    
                }else {
                    completionHandlerForUserID(false ,nil,"\( error!.localizedDescription)")
                   // completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                }
                
                
            }
        }
    
    }
   
        
    func postUserLocation( jsonBody: String ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        _ = taskForPOSTMethod(Methods.StudentLocation, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil{
                    completionHandlerForSession(true ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
    }
    
    func putUserLocation( jsonBody: String ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, the API method, and the HTTP body (if POST) */
        
        
        /* 2. Make the request */
        
        var mutableMethod: String = Methods.StudentLocationUpdate
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.ObjectId, value: String(self.objectId!))!
        
        _ = taskForPUTMethod(mutableMethod, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil {
                    completionHandlerForSession(true  ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    }








