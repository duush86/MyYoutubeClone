//
//  FeedCell.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/11/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class FeedCell: BaseCell {
    
    var videosToUse: [Video] = []
    
    var channelsForVideosDictionary: [String : Channel]?
    
    var datesDictionary: [String: String]?

    
    lazy var collectionView: UICollectionView = {
        
       let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .white
        
        cv.dataSource = self
        
        cv.delegate = self
        
        return cv
    }()
    
    let cellid = "cellid"
    
    override func setupViews() {
        
        super.setupViews()
                
        addSubview(collectionView)
        
        getVideosFromPlaylist(playlist: ConfigConstants.latestPL)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCellCollectionViewCell.self, forCellWithReuseIdentifier: cellid)
                
    }
    
    func usePlaylist(withVideos videos: [BCOVVideo], withChannels channels: [String : Channel], withDates dates: [String : String]){
        
       // videosToUse = []
        
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
            
            videosToUse.append(myBCVideo)
            
        }
        
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            
        }
        
        
    }

}

extension FeedCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videosToUse.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! VideoCellCollectionViewCell
        
        cell.video = videosToUse[indexPath.item]
        
        return cell
        
    }
    
    
    
    
}

extension FeedCell: UICollectionViewDelegate {
    
    
}

extension FeedCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = (frame.width - 32) * 9 / 16
        
        return CGSize(width: frame.width, height: height + 16 + 110)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
}

extension FeedCell: ReloadDelegate {
    
    @objc func didUpdateAnalytics(forVideo video: Video) {
                  
        let indexOfItem = videosToUse.firstIndex(of: video)
        
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
