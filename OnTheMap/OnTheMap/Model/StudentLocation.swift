//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by makramia on 05/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//

import Foundation
struct StudentLocation {
    
    // MARK: Properties
    
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mediaURL: String?
    let mapString: String?
    let latitude: Double?
    let longitude: Double?

    
    // MARK: Initializers
    
    // construct a StudentLocation from a dictionary
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] as? Double
       
    }
    
    static func studentLocationFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
}

// MARK: - StudentLocation: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.objectId == rhs.objectId
}
