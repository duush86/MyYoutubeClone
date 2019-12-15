//
//  VideoCellCollectionViewCell.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 11/29/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews(){
        
    }
    
    required init?(coder: NSCoder) {
       
        fatalError("init(coder:) has not been implemented")

    }
}

class VideoCellCollectionViewCell: BaseCell {
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
                
        setupViews()
    }
        
    var video: Video? {
        
        didSet {
            
            fetchAnalyticsData()
            
            fetchImage()
                        
            thumbnailImageView.contentMode = .scaleToFill
            
          //guard let channelName = video?.channel?.name, let creation_date = video?.uploadDate else {
          guard let channelName = video?.channel?.name, let creation_date = video?.uploadDate, let nov = video?.numberOfViews else {

                print("Cannot get details on videos or channel")
                
                let subtitleText = ""
                
                subtitleTextView.text = subtitleText
                
                userProfileImageView.image = nil
                
                titleLabel.text = ""
            
                return
            }
            
            titleLabel.text = video?.title
            
            let numberFormatter = NumberFormatter()
            
            numberFormatter.numberStyle = .decimal

           
            
            let subtitleText = "\(channelName) - \(numberFormatter.string(from: nov)!) views - Since \(createDateString(from: creation_date))"
            //let subtitleText = "\(channelName) - X views - Since \(createDateString(from: creation_date))"

            userProfileImageView.image = UIImage(named: channelName)
            
            
            subtitleTextView.text = subtitleText
    
    
            //measure title text
            guard let title = video?.title else {
            
                print("Unable to get title")
                
                return
            
            }
            
            let estimatedRect = NSString(string: title).boundingRect(with: CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)], context: nil)
            
            if estimatedRect.size.height > 20 {
                
               // titleLabelHeightConstraint?.constant = 44
                
            } else {
                
                //titleLabelHeightConstraint?.constant = 20
                
            }
            
            
        }
        
        
        
    }
    
    func fetchImage(){
        
        if let thumbnailImageURL = video?.thumbnailImageName {
            
            thumbnailImageView.cacheThumbnail(forThumbnailURL: thumbnailImageURL as NSString)
        
        }
        
    }
    
    
    func fetchAnalyticsData(){
            
        video?.fetchAnalytics()
        
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
    
    let thumbnailImageView: CustomImageView = {
        
        let imageView = CustomImageView()
        
        imageView.clipsToBounds = true
                
        return imageView
        
    }()
    
    let separatorView: UIView = {
    
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        
        return view
    
    }()
    
    let userProfileImageView : UIImageView = {
        
        let imageView = UIImageView()
                       
        //imageView.image = UIImage(named: "k_icon")
        
        imageView.layer.cornerRadius = 22
        
        imageView.layer.masksToBounds = true
                       
        return imageView
        
        
    }()
    
    let titleLabel: UILabel = {
        
        let label = UILabel()
                
        label.translatesAutoresizingMaskIntoConstraints = false
                
        label.numberOfLines = 0
        
        return label
        
    }()
    
    let subtitleTextView: UITextView = {
        
        let textView = UITextView()
                
        textView.text = ""
        
        textView.isEditable = false
        
        textView.isSelectable = false
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)

        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
        
    }()
    
    let moreInfoImage: UIImageView = {
       
        let imageView = UIImageView()
                
        imageView.image = UIImage(systemName: "info.circle")
        
        return imageView
        
    }()
    
    required init?(coder: NSCoder) {
     
        fatalError("init(coder:) has not been implemented")
    
    }
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    
    override func setupViews()  {
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        
        //Horizontal constraints
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
       
        //addConstraintsWithFormat(format: "H:[v0(20)]-8-|", views: moreInfoImage)
        
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)

       
        //Vertical constraints
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView,userProfileImageView, separatorView)
        
        //addConstraintsWithFormat(format: "V:|-8-[v0]", views: moreInfoImage)
        
        //TITLE LABEL
        //top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //right constraints
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //height constraint
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
       
        addConstraint(titleLabelHeightConstraint!)
        
        //SUBTITLE
        //top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        
        //left constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        
        //right constraints
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
    }
    
}
