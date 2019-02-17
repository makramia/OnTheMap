//
//  StudentDataArray.swift
//  OnTheMap
//
//  Created by makramia on 05/01/2019.
//  Copyright © 2019 makramia. All rights reserved.
//

import Foundation

class StudentDataArray {
    static let shared = StudentDataArray()
    
    var usersDataArray = [StudentLocation?]()
    
    private init() { }
}
