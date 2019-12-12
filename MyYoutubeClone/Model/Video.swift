//
//  Video.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/2/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

protocol ReloadDelegate {
    
    func didUpdateAnalytics(forVideo video: Video)
    
}

class Video: NSObject {
    
    var delegate: ReloadDelegate?
    
    var bcovId: String?
    
    var title: String?
    
    var thumbnailImageName: String?
    
    var thumbnailImage: UIImage?
    
    var channel: Channel?
    
    var numberOfViews: NSNumber?
    
    var uploadDate: String?
    
    let analyticsCache = NSCache<AnyObject, AnyObject>()
    
    func fetchAnalytics(){
        
        let video = self
        
        if let analyticCache = analyticsCache.object(forKey: video.bcovId as! NSString)  {
            
            self.numberOfViews = analyticCache as? NSNumber
            
            print("Cache analytics")
            
            return
            
        }
        
        let proxyURL = URL(string: "https://solutions.brightcove.com/aorozco/analytics_proxy.php")
        
        let json: [String: Any] = ["requestType": "GET",
                                   "url": "https://analytics.api.brightcove.com/v1/alltime/accounts/6030890615001/videos/\(video.bcovId!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: proxyURL!)
        
        request.httpMethod = "POST"
        
        request.httpBody = jsonData
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                
                print(error as! Error)
                
                return
                
            }
            guard let dataResponse = data else {
                
                print("Issues getting the data")
                
                return
            }
            
            
            let responseJSON = try? JSONSerialization.jsonObject(with: dataResponse, options: [])
            
            if let responseJSON = responseJSON as? [String: Any] {
                
                let responseValue = responseJSON["alltime_video_views"]! as! NSNumber
                
                self.analyticsCache.setObject(responseValue, forKey: video.bcovId as! NSString)
                
                self.numberOfViews = responseValue
                
                print("Fetching analytics")
                
                self.delegate?.didUpdateAnalytics(forVideo: video)
                
            }
            
            
            
            
        }
        
        task.resume()
        
        
    }
}

class Channel: NSObject, Decodable {
    
    var name: String?
    
    var profileImageName: String?
}
