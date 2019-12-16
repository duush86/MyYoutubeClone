//
//  VideoLauncher.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/13/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class VideoLauncher:  UIView, BCOVPlaybackControllerDelegate {
    
    //  var homeController: HomeController?
    
    let labelVideoTitle: UILabel = {
             
              let lvt = UILabel()
              
              //lvt.backgroundColor = .black
              
              //lvt.text = video.title
              
              lvt.translatesAutoresizingMaskIntoConstraints = false
              
              return lvt
          }()
    
    let labelVideoDescription: UITextView = {
        
        let lvd = UITextView()
        
        //lvd.backgroundColor = .black
        
        //lvd.text = createDateString(from: video.uploadDate!)
        
        lvd.isEditable = false
        
        lvd.isSelectable = false
        
        lvd.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        lvd.translatesAutoresizingMaskIntoConstraints = false
                    
        return lvd
    }()
    
    let labelTotalViews: UILabel = {
        
        let ltv = UILabel()
        
        //ltv.backgroundColor = .black
        
       // ltv.text = "Total Number of views: \(numberFormatter.string(from: video.numberOfViews!)!)"
        
        ltv.translatesAutoresizingMaskIntoConstraints = false
                    
        return ltv
    }()
    
    let numberFormatter = NumberFormatter()
                     
//    numberFormatter.numberStyle = .decimal
    
    func showVideoPlayer(forVideo video: Video){
        
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        
        if window == nil {
            
            print("Unable to get the window")
            
            return
            
        }
        
        let view = UIView(frame: window!.frame)
        
        view.backgroundColor = .white
        
        view.frame = CGRect(x: window!.frame.width - 10, y: window!.frame.height - 10, width: 10, height: 10)
        
        let height = window!.frame.width * 9 / 16
        
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: window!.frame.width, height: height)
        
        window!.addSubview(view)
        
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        
        view.addSubview(videoPlayerView)
        
        let playbackServiceRequestFactory = BCOVPlaybackServiceRequestFactory(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
        
        let playbackService = BCOVPlaybackService(requestFactory: playbackServiceRequestFactory)
        
        playbackService?.findVideo(withVideoID: video.bcovId, parameters: nil, completion: { [weak self] (bcvideo: BCOVVideo?, jsonResponse: [AnyHashable:Any]?, error: Error?) in
            
            if let bcv = bcvideo {
                
                
                videoPlayerView.playbackController?.setVideos([bcv] as NSFastEnumeration)
                
                videoPlayerView.playbackController?.isPictureInPictureActive = true
                
                
            } else {
                print("No video for ID \"\(video)\" was found.")
                
            }
            
        } )
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            view.frame = window!.frame
            
            
        }, completion: { (completedAnimation) in
            
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            
        })
        
        setupVideoInfoView(forVideo: video, withVideoLayer: videoPlayerView)
        
        displayVideoInfo(forVideo: video)
        
        
    }
    
    func displayVideoInfo(forVideo video: Video) {
        
        labelVideoTitle.text = "\(video.title!)"
        
        
        // ltv.text = "Total Number of views: \(numberFormatter.string(from: video.numberOfViews!)!)"
        numberFormatter.numberStyle = .decimal
        
        labelVideoDescription.text = "\(numberFormatter.string(from: video.numberOfViews!)!) views since \(createDateString(from: video.uploadDate!))"
        
    }
    
    func setupVideoInfoView(forVideo video: Video, withVideoLayer videoLayer: UIView){
        
        
        videoLayer.addSubview(labelVideoTitle)
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelVideoTitle, attribute: .top, relatedBy: .equal, toItem: videoLayer, attribute: .bottom, multiplier: 1, constant: 20))
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelVideoTitle, attribute: .left, relatedBy: .equal, toItem: videoLayer, attribute: .left, multiplier: 1, constant: 20))

        labelVideoTitle.addConstraint(NSLayoutConstraint(item: labelVideoTitle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20))

        labelVideoTitle.addConstraint(NSLayoutConstraint(item: labelVideoTitle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200))
        

        
        videoLayer.addSubview(labelVideoDescription)
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelVideoDescription, attribute: .top, relatedBy: .equal, toItem: labelVideoTitle, attribute: .bottom, multiplier: 1, constant: 20))
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelVideoDescription, attribute: .left, relatedBy: .equal, toItem: videoLayer, attribute: .left, multiplier: 1, constant: 20))

        labelVideoDescription.addConstraint(NSLayoutConstraint(item: labelVideoDescription, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20))

        labelVideoDescription.addConstraint(NSLayoutConstraint(item: labelVideoDescription, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200))
        

//        numberFormatter.numberStyle = .decimal
        

        
        videoLayer.addSubview(labelTotalViews)
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelTotalViews, attribute: .top, relatedBy: .equal, toItem: labelVideoDescription, attribute: .bottom, multiplier: 1, constant: 20))
        
        videoLayer.addConstraint(NSLayoutConstraint(item: labelTotalViews, attribute: .left, relatedBy: .equal, toItem: videoLayer, attribute: .left, multiplier: 1, constant: 20))

        labelTotalViews.addConstraint(NSLayoutConstraint(item: labelTotalViews, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20))

        labelTotalViews.addConstraint(NSLayoutConstraint(item: labelTotalViews, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 200))
      


        
    }
    
    func createDateString(from dateString: String) -> String {
           
           let dateFormatter = DateFormatter()
           
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
           
           let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
           
           dateFormatter.locale = enUSPosixLocale
           
           dateFormatter.calendar = Calendar(identifier: .gregorian)
           
           let date = dateFormatter.date(from: dateString)
           
           return date!.timeAgoSinceDate()
           
       }
}

class VideoPlayerView: UIView, BCOVPlaybackControllerDelegate {
    
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    
    let playbackService = BCOVPlaybackService(accountId: ConfigConstants.AccountID, policyKey: ConfigConstants.PolicyKey)
    
    var playbackController :BCOVPlaybackController?
    
    var delegate: BCOVPUIPlayerViewDelegate?
    
    var isFullScreen: Bool = false
    
    let dismissPlayerButton: UIButton = {
        
        let myButton = UIButton()
        
        myButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        var iconImage = UIImage(named: "cancel")
        
        myButton.setImage(iconImage, for: .normal)
        
        myButton.imageView?.contentMode = .scaleAspectFit
        
        myButton.translatesAutoresizingMaskIntoConstraints = false
        
        myButton.isEnabled = true
        
        myButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        return myButton
        
    }()
    
    
    override init(frame: CGRect) {
        
        playbackController = (sharedSDKManager?.createPlaybackController())!
        
        super.init(frame: frame)
        
        playbackController?.analytics.account = ConfigConstants.AccountID // Optional
        
        playbackController!.delegate = self
        
        playbackController!.isAutoPlay = true
        
        playbackController?.isPictureInPictureActive = true
        
        let options = BCOVPUIPlayerViewOptions()
        
        options.showPictureInPictureButton = true
        
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        
        options.presentingViewController = window?.rootViewController
        
        guard let playerView = BCOVPUIPlayerView(playbackController: self.playbackController, options: options, controlsView: BCOVPUIBasicControlView.withVODLayout()) else {
            return
        }
        
        // Install in the container view and match its size.
        self.addSubview(playerView)
        
        playerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            playerView.topAnchor.constraint(equalTo: self.topAnchor),
            playerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            playerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        
        
        playerView.overlayView.addSubview(dismissPlayerButton)
        
        playerView.overlayView.addConstraintsWithFormat(format: "H:|-8-[v0(20)]|", views: dismissPlayerButton)
        playerView.overlayView.addConstraintsWithFormat(format: "V:|-10-[v0(20)]", views: dismissPlayerButton)
        
        
        playerView.delegate = self
        
        // Associate the playerView with the playback controller.
        playerView.playbackController = playbackController
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init has not been implemented ")
    }
    
    @objc func dismissButtonPressed(sender: UIButton) {
        
        print("Dismiss button pressed")
        
        superview!.frame = CGRect(x: window!.frame.width, y: window!.frame.height, width: 1, height: 1)
        
        superview!.backgroundColor = UIColor(white: 0, alpha: 1.0)
        
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
        
        playbackController?.pause()
        
    }
    
    
    
}
extension VideoPlayerView: BCOVPUIPlayerViewDelegate {
    
    func playerView(_ playerView: BCOVPUIPlayerView!, willTransitionTo screenMode: BCOVPUIScreenMode) {
        
        if isFullScreen == true
        {
            isFullScreen = false
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .layoutSubviews, animations: {
                
                self.superview!.frame = self.window!.frame
                
                self.superview?.backgroundColor = UIColor.init(white: 1, alpha: 1.0)
                
                playerView.overlayView.isHidden = false
                
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
                
                
            }, completion: { (completedAnimation) in
                
                
                
            })
            
        } else {
            
            isFullScreen = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .layoutSubviews, animations: {
                
                self.superview!.frame = CGRect(x: self.window!.frame.width, y: self.window!.frame.height, width: 0, height: 0)
                
                self.superview!.backgroundColor = UIColor(white: 1, alpha: 1.0)
                
                playerView.overlayView.isHidden = true
                
                UIApplication.shared.setStatusBarHidden(false, with: .fade)
                
            }, completion: { (completedAnimation) in
                
                
                
            })
            
        }
        
        
    }
    
    func playbackController(_ controller: BCOVPlaybackController!, playbackSession session: BCOVPlaybackSession!, didReceive lifecycleEvent: BCOVPlaybackSessionLifecycleEvent!) {
        
        guard let type = lifecycleEvent.eventType else {
            
            print("Unable to get player event")
            
            return
        }
        
        switch type {
        case "kBCOVPlaybackSessionLifecycleEventPlaybackStalled":
            //DO SOMETHING TO DISPLAY A SPIN WHEEL
            print("Player is buffering")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackRecovered":
            //DO SOMETHING TO DISMISS THE SPIN WHEEL
            print("Player is not buffering anymore")
        case "kBCOVPlaybackSessionLifecycleEventPlay":
            print("Play")
        case "kBCOVPlaybackSessionLifecycleEventPause":
            print("Pause")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackBufferEmpty":
            print("Buffering")
        case "kBCOVPlaybackSessionLifecycleEventPlaybackLikelyToKeepUp":
            print("Ready to play again")
        default:
            print("Do Nothing")
        }
        
        
    }
    
}

