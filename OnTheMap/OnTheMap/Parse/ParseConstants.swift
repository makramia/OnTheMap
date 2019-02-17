//
//  Constants.swift
//  OntheMap
//
///  Created by makramia on 04/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//


import UIKit

// MARK: - Constants
extension ParseClient{
    

    struct Constants {
        
        // MARK: API Key
        
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: Parse URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        }

        
        // MARK: Methods
        struct Methods {
            
            // MARK: Account
            static let StudentLocation = "/StudentLocation"
            static let StudentLocationUpdate = "/StudentLocation/{id}"
            
        }
        
        // MARK: URL Keys
        struct URLKeys {
            static let UserID = "id"
            static let ObjectId = "id"
            
        }
        
        // MARK: Parse Parameter Keys
        struct ParameterKeys {
                        
            static let Order = "order"
            static let Limit = "limit"
            static let Where = "where"
        }
        
        // MARK: Parameter Values
        struct ParameterValues {
            static let Order = "-updatedAt"
            static let Limit = "100"
            static let Where = "{\"uniqueKey\":\"{id}\"}"
            
            
        }
        
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            
                        
            // MARK: Authorization
            
            static let SessionID = "session_id"
            static let Session = "session"
            // MARK: Account
            static let UserID = "id"
            
            // MARK: StudentLocation
            static let objectId = "objectId"
            static let uniqueKey = "uniqueKey"
            static let firstName = "firstName"
            static let lastName = "lastName"
            static let mediaURL = "mediaURL"
            static let mapString =  "mapString"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let Results = "results"
            
    
        }
        
    }


