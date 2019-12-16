//
//  MenuBar.swift
//  MyYoutubeClone
//
//  Created by Antonio Orozco on 12/2/19.
//  Copyright © 2019 Antonio Orozco. All rights reserved.
//

/*
 
 ManuBar class, defines the UI elements for a menbar. It related with the HomeController as its where it lives on the App cycle.
 
 */

import UIKit

class MenuBar: UIView {
    
    //The menu is built out with the following collectionView.
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
        
        cv.dataSource = self
        
        cv.delegate = self
        
        return cv
        
    }()
    
    let cellId = "cellId"
    
    var homeController: HomeController?
    
    let imageNames = ["home", "trending", "subscriptions", "account"]
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .top)
        
        setupHorizontalBar()
        
    }
    
    var horizontalBarLeftAnchoConstraint: NSLayoutConstraint?
    
    /*
     Function to setuo the bar that highlights the menu select item
     */
    
    func setupHorizontalBar(){
        
        let horizontalBarView = UIView()
        
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(horizontalBarView)

        //The bar left anchor is equal to the self host left anchor
        horizontalBarLeftAnchoConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        horizontalBarLeftAnchoConstraint!.isActive = true
        
        //The bar bottom anchor is equal to the self host left anchor
        let horizontalBarBottomAnchoConstraint = horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        horizontalBarBottomAnchoConstraint.isActive = true
        
         //The bar with anchor is 1/4 of the self host width anchor
        let horizontalBarWidthAnchoConstraint = horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4)
        
        horizontalBarWidthAnchoConstraint.isActive = true
        
        //The bar height anchor
        let horizontalBarHeightAnchoConstraint = horizontalBarView.heightAnchor.constraint(equalToConstant: 3)
        
        horizontalBarHeightAnchoConstraint.isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder: has not been implemented")
        
    }
}

//MARK: - Delegate methods to populate the Menu Bar UICollection View items.
extension  MenuBar: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
                
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
                
        cell.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13)
        
        return cell
        
    }
    
    
}

extension MenuBar: UICollectionViewDelegate {
    
    
}

//MARK: - Delegate methods to customize the UICollectionView style
extension MenuBar: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: frame.width / 4, height: frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    
    }
    
    //This method is called when the user tabs on one of the menu's elements. It calls the homeController object to update the UI accordingly.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                   
        let x = CGFloat(indexPath.item) * self.frame.width / 4

        horizontalBarLeftAnchoConstraint!.constant = x
        
        homeController?.scrollToManuIndex(menuIndex: indexPath.item)
    }
        
    
    
}
//MARK: - Defines de Menu Cell elements, it inherits from BaseCell as well.

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
       
        let iv = UIImageView()
                
        return iv
        
    }()
    
    override var isHighlighted: Bool {
        
        didSet {
            
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 14)
        
        }
        
    }
    
    override var isSelected: Bool {
           
           didSet {
               
               imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 14)
           
           }
           
       }
    
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
    }
    
}
