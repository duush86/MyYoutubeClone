//
//  BaseVideoViewController.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/2/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class BaseVideoViewController: UICollectionViewController,  BCOVPlaybackControllerDelegate {
    
    private lazy var authProxy: BCOVFPSBrightcoveAuthProxy? = {
        // Publisher/application IDs not required for Dynamic Delivery
        let _authProxy = BCOVFPSBrightcoveAuthProxy(publisherId: nil, applicationId: nil)
        
        // You can use the same auth proxy for the offline video manager
        // and the call to create the FairPlay session provider.
        BCOVOfflineVideoManager.shared()?.authProxy = _authProxy
        
        return _authProxy
    }()
    
    var playbackController: BCOVPlaybackController?
    
    var delegate: BCOVPUIPlayerViewDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        playbackController?.pause()
        
    }
    
    func createNewPlaybackController(onView videoContainerView: UIView) -> BCOVPlaybackController? {
        let playerView: BCOVPUIPlayerView? = {
            
            let options = BCOVPUIPlayerViewOptions()
            options.presentingViewController = self
            
            var delegate: BCOVPUIPlayerViewDelegate?
            
            // Create PlayerUI views with normal VOD controls.
            let controlView = BCOVPUIBasicControlView.withVODLayout()
            guard let _playerView = BCOVPUIPlayerView(playbackController: nil, options: options, controlsView: controlView) else {
                return nil
            }
            
            // Add to parent view
            videoContainerView.addSubview(_playerView)
            _playerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                _playerView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
                _playerView.rightAnchor.constraint(equalTo: videoContainerView.rightAnchor),
                _playerView.leftAnchor.constraint(equalTo: videoContainerView.leftAnchor),
                _playerView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor)
            ])
            
            // Receive delegate method callbacks
            _playerView.delegate = self
            
            return _playerView
        }()
        
        // This app shows how to set up your playback controller for playback of FairPlay-protected videos.
        // The playback controller, as well as the download manager will work with either FairPlay-protected
        // videos, or "clear" videos (no DRM protection).
        let sdkManager = BCOVPlayerSDKManager.shared()
        
        // Create the session provider chain
        let options = BCOVBasicSessionProviderOptions()
        options.sourceSelectionPolicy = BCOVBasicSourceSelectionPolicy.sourceSelectionHLS(withScheme: kBCOVSourceURLSchemeHTTPS)
        //guard let basicSessionProvider = sdkManager?.createBasicSessionProvider(with: options), let authProxy = self.authProxy else {
        //     return
        //}
        //let fairPlaySessionProvider = sdkManager?.createFairPlaySessionProvider(withApplicationCertificate: nil, authorizationProxy: authProxy, upstreamSessionProvider: basicSessionProvider)
        
        // Create the playback controller
        let _playbackController = sdkManager?.createPlaybackController()
        //fairPlaySessionProvider, viewStrategy: nil)
        
        // Start playing right away (the default value for autoAdvance is false)
        _playbackController?.isAutoAdvance = true
        _playbackController?.isAutoPlay = false
        
        // Register the delegate method callbacks
        _playbackController?.delegate = self
        
        playerView?.playbackController = _playbackController
        
        playbackController = _playbackController
        
        return playbackController!
    }
    
}

extension BaseVideoViewController: BCOVPUIPlayerViewDelegate {
    
    func playerView(_ playerView: BCOVPUIPlayerView!, willTransitionTo screenMode: BCOVPUIScreenMode) {
        // Hide the tab bar when we go full screen
        tabBarController?.tabBar.isHidden = screenMode == .full
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
