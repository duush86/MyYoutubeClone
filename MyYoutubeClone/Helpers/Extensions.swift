//
//  Extensions.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/1/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for(index, view) in views.enumerated(){
            
            let key = "v\(index)"
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            viewsDictionary[key] = view
            
        }
    
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    
    }
    
}
