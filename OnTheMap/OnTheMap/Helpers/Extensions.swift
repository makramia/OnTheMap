//
//  Extensions.swift
//  OnTheMap
//
//  Created by makramia on 05/01/2019.
//  Copyright © 2019 makramia. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /**
     Property used to identify the activity indicator. Default valye is `999999`
     but this can be overridden.
     */
    public var activityIndicatorTag: Int { return 999999 }
    
    /**
     Creates and starts an UIActivityIndicator in any UIViewController
     Parameter style: `UIActivityIndicatorViewStyle` default is .whiteLarge
     Parameter location: `CGPoint` if not specified the `view.center` is applied
     */
    public func startActivityIndicator(_ style: UIActivityIndicatorView.Style = .whiteLarge, location: CGPoint? = nil) {
        
        let loc = location ?? self.view.center
        
        DispatchQueue.main.async(execute: {
            let activityIndicator = UIActivityIndicatorView(style: style)
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = loc
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        })
    }
    
    /**
     Stops and removes an UIActivityIndicator in any UIViewController
     */
    public func stopActivityIndicator() {
        
        DispatchQueue.main.async(execute: {
            if let activityIndicator = self.view.subviews.filter({ $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        })
    }
}

// MARK: UI
struct UI {
    static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
    static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
    static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
    static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
}
