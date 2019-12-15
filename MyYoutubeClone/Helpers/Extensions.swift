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

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "a moment ago"
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
     var imageURLString : NSString?
    
     func cacheThumbnail(forThumbnailURL thumbnailURLString: NSString){
                
        guard  let thumbnailURL = URL(string: thumbnailURLString as String) else {
            
            return
            
        }
     
        imageURLString = thumbnailURLString
        
        image = UIImage(named: "load")
        
        if let imageFromCache = imageCache.object(forKey: thumbnailURLString)  {
                    
           self.image = imageFromCache as? UIImage
           
            //print("cache image")
            
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: thumbnailURL) { (data, response, error) in
            
            if error != nil {
                
                print(error as! Error)
                
                return
                
            }
            
           DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageURLString == thumbnailURLString {
                
                self.image = imageToCache
                    
                //print("Loading image")
                                 
                imageCache.setObject(imageToCache!, forKey: thumbnailURLString)

        }
             

                
            }
            
            
        }
        
        task.resume()
        
        
        
    }
    
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
