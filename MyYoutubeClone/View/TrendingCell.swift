//
//  TrendingCell.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/12/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class TrendingCell: FeedCell {
     
     var videosToUseT: [Video] = []

      override func setupViews() {
          
          super.setupViews()

          getVideosFromTrendingPlaylist(playlist: "1651847596733298880")

      }
    
    
    func getVideosFromTrendingPlaylist(playlist: String) {
        
        print("getting videos for playlist: \(playlist)")
        
        var channelsForVideosDictionaryT: [String : Channel]?
           
        var datesDictionaryT: [String: String]?
       
        let queryParams = ["limit": 100, "offset": 0]
        
        let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
        
        let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
        
        playbackService?.findPlaylist(withPlaylistID: playlist, parameters: queryParams, completion: { [weak self] (playlist: BCOVPlaylist?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
            
            
            if let playlist = playlist, let videos = playlist.videos as? [BCOVVideo] {
                
                print("We have some videos ")
                
                var index: Int = 0
                
                channelsForVideosDictionaryT = [:]

                datesDictionaryT = [:]
                
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
                        
                        channelsForVideosDictionaryT?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = channel
                        
                        datesDictionaryT?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = creationDate
                        
                        index += 1
                    }
                }
                
                
                self!.usePlaylistForT(withVideos: videos,withChannels: channelsForVideosDictionaryT!, withDates: datesDictionaryT!)
                
                
            }else {
                
                print("No videos for playlist")
                
            }
            
        })
        
    }
    
    
    func usePlaylistForT(withVideos videos: [BCOVVideo], withChannels channels: [String : Channel], withDates dates: [String : String]){
              
        //videosToUse = []
        
        
        for video in videos {
            
            let myBCVideo : Video = {
                
                let v = Video()
                
                v.title = video.properties[kBCOVVideoPropertyKeyName] as? String
                
                v.thumbnailImageName = video.properties[kBCOVVideoPropertyKeyPoster] as? String
                
                v.bcovId = video.properties[kBCOVVideoPropertyKeyId] as? String
                
                v.channel = channels[v.bcovId!]
                
                v.uploadDate = dates[v.bcovId!]
                
                v.delegate = self
                
                return v
                
            }()
            
            videosToUseT.append(myBCVideo)
            
        }
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            
        }
        
        
    }
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videosToUseT.count
        
    }
    
    
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! VideoCellCollectionViewCell
        
        cell.video = videosToUseT[indexPath.item]
        
        return cell
        
    }
    
    override func didUpdateAnalytics(forVideo video: Video) {
        
        let indexOfItem = videosToUseT.firstIndex(of: video)
        
        guard let itemToFind = indexOfItem else {
            
            print("Unable to find video")
            
            return
            
        }
        
        let item: IndexPath = IndexPath(item: itemToFind, section: 0)
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadItems(at: [item])
            
        }
        
        
    }
    
    
}

    
  
    
