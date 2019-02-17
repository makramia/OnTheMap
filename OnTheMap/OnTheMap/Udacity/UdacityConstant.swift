//
//  UdacityConstant.swift
//  OnTheMap
//
//  Created by makramia on 04/01/2019.
//  Copyright © 2019 makramia. All rights reserved.
//

import Foundation
import  UIKit

extension UdacityClient{
    
    
    struct Constants {
        
        // MARK: Udacity URLs
        static let ApiScheme = "https"
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
        
        
    }
        
        // MARK: Methods
        struct Methods {
            
            
            // MARK: Authentication
            static let AuthenticationSession = "/session"
            static let AuthenticationGetPublicDataForUserID = "/users/{id}"
            
        }
        
        // MARK: URL Keys
        struct URLKeys {
            static let UserID = "id"
            //static let ObjectId = "id"
            
        }
    
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            
            // MARK: Authorization
            
            static let SessionID = "id"
            static let Session = "session"
            static let Account = "account"
            // MARK: Account
            static let UserID = "key"
            static let User = "user"
            static let nickName = "nickname"
                        
            
        }
            
}


