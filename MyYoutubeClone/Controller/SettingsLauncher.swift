//
//  SettinhsLauncher.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/4/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

import Foundation
import UIKit


class Setting: NSObject {
    
    let name: SettingName
    
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        
        self.name = name
        
        self.imageName = imageName
        
    }
}

enum SettingName: String {
    
    case Cancel = "Cancel and Dismiss"
    case Settings = "Settings"
    case TermsAndConditions = "Terms and Conditions"
    case SendFeedback = "SendFeedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
    
    
}

class SettingsLauncher: NSObject {
    
    let blackView = UIView()
    
    let collecionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let cv =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor.white
        
        return cv
    }()
    
    let cellId = "cellId"
    
    let cellHeight = 50
    
    let settings: [Setting] = {
        
        let cancelSetting = Setting(name: .Cancel, imageName: "Cancel")
        
        return  [Setting(name: .Settings, imageName: "settings"),
                 Setting(name: .TermsAndConditions, imageName: "lock"),
                 Setting(name: .SendFeedback, imageName: "feedback"),
                 Setting(name: .Help, imageName: "help"),
                 Setting(name: .SwitchAccount, imageName: "s_account"),
                 Setting(name: .Cancel, imageName: "cancel")]
    }()
    
    var homeController: HomeController?
    
    @objc func showSettings() {
        
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        
        if window != nil {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window!.addSubview(blackView)
            
            window!.addSubview(collecionView)
            
            let height: CGFloat = CGFloat(settings.count * cellHeight)
            
            let y: CGFloat = window!.frame.height - height
            
            collecionView.frame = CGRect(x:0, y:window!.frame.height, width:window!.frame.width, height:height)
            
            blackView.frame = window!.frame
            
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collecionView.frame = CGRect(x:0,y:y,width:self.collecionView.frame.width,height:self.collecionView.frame.height)
                
            }, completion: nil)
            
            
            
        }
        
    }
    
    @objc func handleDismiss(){
        
        UIView.animate(withDuration: 0.5) {
            
            self.blackView.alpha = 0
            
            let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
            
            if window != nil {
                
                self.collecionView.frame = CGRect(x: 0, y: window!.frame.height, width: window!.frame.width, height: window!.frame.height)
                
            }
            
        }
        
    }
    
    override init() {
        
        super.init()
        
        collecionView.dataSource = self
        
        collecionView.delegate = self
        
        collecionView.register(SettingCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    
    
}

extension SettingsLauncher: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return settings.count
        
    }
}

extension SettingsLauncher: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.row]
        
        cell.setting = setting
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
                
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.handleDismiss()
            
        }, completion: {(completed: Bool) in
            
            let setting = self.settings[indexPath.item]

          if  setting.name != .Cancel {
                
                self.homeController?.showControllerForSetting(setting: setting)
                
            }
            
        })
        
        
        
    }
    
}

extension SettingsLauncher: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 50)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
}
