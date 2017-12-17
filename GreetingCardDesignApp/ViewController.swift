//
//  ViewController.swift
//  GreetingCardDesignApp
//
//  Created by AKIL KUMAR THOTA on 12/16/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var colors = [UIColor]()
    
    //IBOutlet
    @IBOutlet weak var postCard: UIImageView!
    @IBOutlet weak var mycollectionView: UICollectionView!
    
    
    //properties
    var image:UIImage?
    
    var topText = "Visit London"
    var topFontName = "Helvetica Neue"
    var topColor = UIColor.white
    
    var bottomText = "It is the home of Sherlock Holms"
    var bottomFontName = "Helvetica Neue"
    var bottomColor = UIColor.white
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColors()
    }
    
    
    fileprivate func setupColors() {
        colors += [.red,.white,.blue,.black,.green,.gray,.orange,.magenta,.purple,.cyan]
        for i in 0...9 {
            for j in 1...10 {
                let color = UIColor(hue: CGFloat(i) / 10, saturation: CGFloat(j) / 10, brightness: 1, alpha: 1)
                colors.append(color)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }

}

