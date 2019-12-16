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
    static let trendingPL = "1651847596733298880"
    static let subscriptionPL = "6054209724001"

}

class HomeController: UICollectionViewController {
    
    let titles = ["Home", "Trending", "Suscriptions","Account"]

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        
        titleLabel.text = "  Home"
        
        titleLabel.textColor = UIColor.white
        
        titleLabel.font = titleLabel.font.withSize(20)
        
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = UIColor.white
        
        let cellid: String = "cellid"
        
        let trendingcellid: String = "trendingcellid"
        
        let subscriptioncellid: String = "subscriptioncellid"
        
        setupCollectionView()
        
        setupMenuBar()
        
        setupNavBarButtons()
        
    }
    
    func setupCollectionView()  {
                
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            flowLayout.scrollDirection = .horizontal
            
            flowLayout.minimumLineSpacing = 0
        }
       
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "cellid")
        
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: "trendingcellid")
        
        collectionView.register(SubscriptionsCell.self, forCellWithReuseIdentifier: "subscriptioncellid")

        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
                    
        collectionView.isPagingEnabled = true
    }
    
    
    lazy var menuBar: MenuBar = {
        
        let mb = MenuBar()
        
        mb.homeController = self
        
        return mb
        
    }()
    
    
   
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView: UIView = {
            
            let view = UIView()
            
            view.backgroundColor = UIColor.rgb(red: 230, green: 30, blue: 31)
            
            return view
            
        }()
        
        view.addSubview(redView)
        
        view.addSubview(menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addConstraintsWithFormat(format:"H:|[v0]|", views: menuBar)
        
        view.addConstraintsWithFormat(format:"V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor).isActive = true
       
    }
    
    private func setupNavBarButtons(){
                
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        
        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
        
    }
    
    
    lazy var settingsLauncher: SettingsLauncher = {
        
       let launcher = SettingsLauncher()
       
        launcher.homeController = self
        
        return launcher
        
    }()
    
    
    
    @objc func handleMore() {
                
        settingsLauncher.showSettings()
        
    }
    
    func showControllerForSetting(setting: Setting){
        
        let dummySettingsViewController = UIViewController()
               
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
        
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        
        dummySettingsViewController.view.backgroundColor = UIColor.white
                
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    @objc func handleDismiss(){
        
        settingsLauncher.handleDismiss()
        
    }
    
    @objc func handleSearch() {
        
        print(123)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    func scrollToManuIndex(menuIndex: Int) {
        
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        
        updateTitle(forIndex: menuIndex)
        
    }
    
    func updateTitle(forIndex index: Int){
        
        if let titleLabel = navigationItem.titleView as? UILabel {
            
            titleLabel.text = "  \(titles[index])"
            
        }
        
    }
    

}



extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        menuBar.horizontalBarLeftAnchoConstraint?.constant = scrollView.contentOffset.x / 4
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var id: String = ""

        if indexPath.item == 1 {
            
            id = "trendingcellid"
            

        } else if indexPath.item == 2 {
            
           id = "subscriptioncellid"
                 
        } else {
            
            id = "cellid"
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       
        let target = targetContentOffset.pointee.x / view.frame.width
        
        let targetIndex: NSIndexPath = NSIndexPath(item: Int(target), section: 0)
        
        menuBar.collectionView.selectItem(at: targetIndex as IndexPath, animated: true, scrollPosition: .top)
       
        updateTitle(forIndex: Int(target))
        
        
    }

    
}


