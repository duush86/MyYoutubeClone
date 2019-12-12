//
//  Brightcove-Service.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/10/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//
import BrightcovePlayerSDK

extension FeedCell {
    
    func getVideosFromPlaylist(playlist: String) {
        
        print("getting videos for playlist: \(playlist)")
        
        
        var channelsForVideosDictionary: [String : Channel]?
           
        var datesDictionary: [String: String]?
       
        let queryParams = ["limit": 100, "offset": 0]
        
        let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
        
        let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
        
        playbackService?.findPlaylist(withPlaylistID: playlist, parameters: queryParams, completion: { [weak self] (playlist: BCOVPlaylist?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
            
            
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
                
                
                self?.usePlaylist(withVideos: videos,withChannels: channelsForVideosDictionary!, withDates: datesDictionary!)
                
                
            }else {
                
                print("No videos for playlist")
                
            }
            
        })
        
    }
    
    
}
