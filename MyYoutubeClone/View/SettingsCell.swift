//
//  SettingsCell.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/5/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {
        
        didSet {
            
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
                        
        }
        
    }
    
    
    var setting: Setting? {
        
        didSet{
            
            nameLabel.text = setting?.name.rawValue
            
            if let imageIcon = setting?.imageName {
                
                iconImageView.image = UIImage(named: imageIcon)?.withRenderingMode(.alwaysTemplate)
                
                iconImageView.tintColor = UIColor.darkGray
                
            }
            
        }
        
    }
    
    let nameLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = "Settings"
        
        label.font = UIFont.systemFont(ofSize: 13)
        
        label.textAlignment = .left
        
        return label
        
    }()
    
    let iconImageView: UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "settings")
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    override func setupViews() {
        
        super.setupViews()
                
        addSubview(nameLabel)
        
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(20)]-8-[v1]|", views: iconImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
       
        addConstraintsWithFormat(format: "V:[v0(20)]", views:iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
