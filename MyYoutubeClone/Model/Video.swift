//
//  Video.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/2/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class Video: NSObject {
    
    var bcovId: String?
    
    var title: String?
    
    var thumbnailImageName: String?
    
    var thumbnailImage: UIImage?
        
    var channel: Channel?
    
    var numberOfViews: NSNumber?
    
    var uploadDate: String?
}

class Channel: NSObject, Decodable {
    
    var name: String?
    
    var profileImageName: String?
}
