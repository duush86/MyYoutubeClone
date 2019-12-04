//
//  ViewController.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 11/28/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

struct ConfigConstants {
    static let AccountID = "6030890615001"
    static let PolicyKey = "BCpkADawqM32nL1Ic9gyo3bITy-1QWVkCxdmpEw9LLw3BrW7TwxPPCaWEq5OoIRzx9E3ydeeS2uir3OOi2ziy2Dh5NjlAqavWfSjyFXkTtHB69KQkyc0-FAXel3bqWzTFdMuFXy0RjhXsecd"
    static let latestPL = "1651847405034787885"
}

class HomeController: BaseVideoViewController, UICollectionViewDelegateFlowLayout {

    var videosToUse: [Video] = []
    
    var imageCacheDictionary: [String: UIImage]?
    
    var channelsForVideosDictionary: [String : Channel]?
    
    var datesDictionary: [String: String]?
//    var videos: [Video] = {
//
//        var indieChannel  = Channel()
//
//        indieChannel.name = "Indie VEVO"
//
//        indieChannel.profileImageName = "indie"
//
//
//
//        var mrBrightsideVideo = Video()
//
//        mrBrightsideVideo.title = "The Killers - Mr. Brightside - Hot Fuss"
//
//        mrBrightsideVideo.thumbnailImageName = "the_killers"
//
//        mrBrightsideVideo.numberOfViews = 123456789012345
//
//        mrBrightsideVideo.channel = indieChannel
//
//
//
//        var missAtomicVideo = Video()
//
//        missAtomicVideo.title = "The Killers - Ms. Atomic Bomb - Battle Born (Delux Edition)"
//
//        missAtomicVideo.thumbnailImageName = "miss_atomic"
//
//        missAtomicVideo.numberOfViews = 123456789012345
//
//        missAtomicVideo.channel = indieChannel
//
//        return [mrBrightsideVideo, missAtomicVideo]
//
//    }()
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        
        titleLabel.text = "Home"
        
        titleLabel.textColor = UIColor.white
        
        titleLabel.font = titleLabel.font.withSize(20)
        
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView.register(VideoCellCollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        getVideosFromPlaylist(playlist: ConfigConstants.latestPL)
                
        setupMenuBar()
        
        setupNavBarButtons()
        
        
    }
    
    
    let menuBar: MenuBar = {
        
        let mb = MenuBar()
        
        return mb
        
    }()
    
    private func getVideosFromPlaylist(playlist: String) {
        
                
                      
        let queryParams = ["limit": 100, "offset": 0]
                        
                        // Retrieve a playlist through the BCOVPlaybackService
        
        let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
                        
        
        let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
                       
        
        playbackService?.findPlaylist(withPlaylistID: playlist, parameters: queryParams, completion: { [weak self] (playlist: BCOVPlaylist?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
                            
            
            if let playlist = playlist, let videos = playlist.videos as? [BCOVVideo] {
             
                print("We have some videos ")
                
                var index: Int = 0
                
                self!.channelsForVideosDictionary = [:]
                
                self!.datesDictionary = [:]
                
                for video in videos {
                    
                    if let arr = jsonResponse!["videos"] as! NSArray? {
                    
                        let dic = arr[index] as! NSDictionary
                        
                        //print(dic)
                        
                        let cf = dic["custom_fields"] as! NSDictionary
                        
                        let channel = Channel()
                                                
                        if cf["channel"] != nil {
                            
                            channel.name = cf.value(forKey: "channel") as? String
                            
                        } else {
                            
                            channel.name = "No channel"

                        }
                        
                        let creationDate = dic["created_at"] as? String
                        
                        //print("the creation date \(dic["created_at"])")
                        
                        self?.channelsForVideosDictionary?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = channel
                        
                        self?.datesDictionary?[video.properties[kBCOVPlaylistPropertiesKeyId] as! String] = creationDate

                        index += 1
                    }
                }
            
                
                self?.usePlaylist(withVideos: videos,withChannels: self!.channelsForVideosDictionary!, withDates: self!.datesDictionary!)
                
                print()
                
             }else {
                
                print("No videos for playlist")
                
            }
                            
        })
        
    }
    
    private func usePlaylist(withVideos videos: [BCOVVideo], withChannels channels: [String : Channel], withDates dates: [String : String]){
        
        imageCacheDictionary = [:]
        
        
        for video in videos {
            
            let myBCVideo : Video = {
                
                let v = Video()
                
                v.title = video.properties[kBCOVVideoPropertyKeyName] as? String
                                
                v.thumbnailImageName = video.properties[kBCOVVideoPropertyKeyPoster] as? String
                
                cacheThumbnail(forVideo: video)
                
                v.bcovId = video.properties[kBCOVVideoPropertyKeyId] as? String
                
               // print(channels)
                
                v.channel = channels[v.bcovId!]
                
                //print(dates)
                
                v.uploadDate = dates[v.bcovId!]
                
                return v
                
            }()
           // print(video.properties[kBCOVVideoPropertyKeyName] as! String)
            
            videosToUse.append(myBCVideo)
            
            
            collectionView.reloadData()
            
        }
        
        //collectionView.reloadData()

        
    }
    
    private func cacheThumbnail(forVideo video: BCOVVideo){
        
        // Async task to get and store thumbnails
        DispatchQueue.global(qos: .default).async {
            
            // videoID is the key in the image cache dictionary
            guard let videoId = video.properties[kBCOVPlaylistPropertiesKeyId] as? String, let thumbnailSources = video.properties[kBCOVVideoPropertyKeyPosterSources] as? [[String:Any]] else {
                
                return
            }
            
            for thumbnailDictionary in thumbnailSources {
                
                guard let thumbnailURLString = thumbnailDictionary["src"] as? String, let thumbnailURL = URL(string: thumbnailURLString) else {
                    
                    return
                    
                }
                
                if thumbnailURL.scheme?.caseInsensitiveCompare("https") == .orderedSame {
                    var thumbnailImageData: Data?
                    
                    do {
                        
                        thumbnailImageData = try Data(contentsOf: thumbnailURL)
                        
                    } catch let error {
                        
                        print("Error getting thumbnail image data: \(error.localizedDescription)")
                        
                    }
                    
                    guard let _thumbnailImageData = thumbnailImageData, let thumnailImage = UIImage(data: _thumbnailImageData) else {
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.imageCacheDictionary?[videoId] = thumnailImage
                        
                        self.collectionView.reloadData()
                                                
                    }
                    
                    
                }
                
            }
            
        }
        
    }
    
    private func setupMenuBar() {
        
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format:"H:|[v0]|", views: menuBar)
        
        view.addConstraintsWithFormat(format:"V:|[v0(50)]", views: menuBar)
        
        
    }
    
    private func setupNavBarButtons(){
        
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        
        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        
    }
    
    
    @objc func handleMore() {
        
        print(321)
        
    }
    
    @objc func handleSearch() {
        
        print(123)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }

    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosToUse.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! VideoCellCollectionViewCell
        
        //cell.thumbnailImageView = video[indexPath.item].
       
        cell.video = videosToUse[indexPath.item]
        
        cell.video?.thumbnailImage = imageCacheDictionary![cell.video!.bcovId!]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let height = (view.frame.width - 32) * 9 / 16
        
        return CGSize(width: view.frame.width, height: height + 16 + 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
}
