//
//  SubscriptionsCell.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/12/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class SubscriptionsCell: FeedCell {
    
    override func setupViews() {
        
        super.setupViews()
        
        fetchVideos()
        
    }
    
    override func fetchVideos() {
        
        APIService.sharedInstance.fetchVideosForPlaylist(withId: ConfigConstants.subscriptionPL, completion: { (videos: [Video] )  in
            
            self.videos = videos
            
            self.collectionView.reloadData()
            
        })
    }
    
}
