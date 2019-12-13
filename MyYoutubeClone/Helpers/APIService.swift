//
//  APIService.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/13/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class APIService: NSObject {
    
    
    static let sharedInstance = APIService()
    
    func fetchVideosForPlaylist(withId playlistId: String, completion: @escaping  ([Video]) -> ()) {
        
        print("getting videos for playlist: \(playlistId)")
                 
         var channelsForVideosDictionary: [String : Channel]?
            
         var datesDictionary: [String: String]?
        
         let queryParams = ["limit": 100, "offset": 0]
        
         var videosForFeed = [Video]()
         
         let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
         
         let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
         
         playbackService?.findPlaylist(withPlaylistID: playlistId, parameters: queryParams, completion: { [weak self] (playlist: BCOVPlaylist?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
             
             if let playlist = playlist, let videos = playlist.videos as? [BCOVVideo] {
                 
                 print("We have some videos ")
                 
                 var index: Int = 0
                 
                 channelsForVideosDictionary = [:]

                 datesDictionary = [:]
                                 
                 for video in videos {
                     
                     if let arr = jsonResponse!["videos"] as! NSArray? {

                         let dic = arr[index] as! NSDictionary
                         
                         let cf = dic["custom_fields"] as! NSDictionary
                         
                         let channel = Channel()
                         
                         if cf["channel"] != nil {
                             
                             channel.name = cf.value(forKey: "channel") as? String
                             
                         } else {
                             
                             channel.name = "No channel"
                             
                         }
                         
                         let creationDate = dic["created_at"] as? String
                         
                         channelsForVideosDictionary?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = channel
                         
                         datesDictionary?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = creationDate
                         
                         index += 1
                     }
                 }
                                     
                videosForFeed = (self?.usePlaylist(withVideos: videos,withChannels: channelsForVideosDictionary!, withDates: datesDictionary!))!
                
                 DispatchQueue.main.async {
                           
                           completion(videosForFeed)
                 }
                 
             }else {
                 
                 print("No videos for playlist")
                 
             }
             
         })
        
       
    }
    
    func usePlaylist(withVideos videos: [BCOVVideo], withChannels channels: [String : Channel], withDates dates: [String : String]) -> [Video]{
        
        var videosToUse: [Video] = []
               
        for video in videos {
            
            let myBCVideo : Video = {
                
                let v = Video()
                
                v.title = video.properties[kBCOVVideoPropertyKeyName] as? String
                
                v.thumbnailImageName = video.properties[kBCOVVideoPropertyKeyPoster] as? String
                
                v.bcovId = video.properties[kBCOVVideoPropertyKeyId] as? String
                
                v.channel = channels[v.bcovId!]
                
                v.uploadDate = dates[v.bcovId!]
                                
                return v
                
            }()
            
            videosToUse.append(myBCVideo)
            
            
        }
        
        return videosToUse
             
    }

}
