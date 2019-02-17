//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by makramia on 04/12/2018.
//  Copyright © 2018 makramia. All rights reserved.
//


import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
