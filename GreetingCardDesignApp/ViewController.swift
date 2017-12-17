//
//  ViewController.swift
//  GreetingCardDesignApp
//
//  Created by AKIL KUMAR THOTA on 12/16/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDragDelegate,UIDropInteractionDelegate,UIDragInteractionDelegate {
    
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
        
        title = "Edit the PostCard"
        
        splitViewController?.view.backgroundColor = UIColor.lightGray
        
        let interaction1 = UIDropInteraction(delegate: self)
        let interaction2 = UIDragInteraction(delegate: self)
        mycollectionView.dragDelegate = self
        postCard.isUserInteractionEnabled = true
        postCard.addInteraction(interaction1)
        postCard.addInteraction(interaction2)
        setupColors()
        renderPostcard()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPressed))
        postCard.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func tapPressed(gesture:UITapGestureRecognizer){
        let location = gesture.location(in: postCard)
        var changeTop = true
        if location.y < self.postCard.bounds.midY {
            changeTop = true
        } else {
            changeTop = false
        }
        let alert = UIAlertController(title: "Enter the Name", message: "Please enter the text you wish to change", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            if changeTop{
                textField.text = self.topText
            }else{
                textField.text = self.bottomText
            }
        }
        let action1 = UIAlertAction(title: "Change", style: .default) { (action) in
            guard let text = alert.textFields?[0].text else {return}
            if changeTop {
                self.topText = text
            }else{
                self.bottomText = text
            }
            self.renderPostcard()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
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
    
    
    func renderPostcard() {
        
        //1 - define the total drawing space
        let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
        
        //2 - define where to draw the top and bottom text
        let topTextRect = CGRect(x: 250, y: 200, width: 2500, height: 800)
        let bottomTextRect = CGRect(x: 250, y: 1800, width: 2500, height: 600)
        
        //3 - create UIFont instances out of the font names, providing fallbacks on failure
        let topFont = UIFont(name: topFontName, size: 350) ?? UIFont.systemFont(ofSize: 250)
        let bottomFont = UIFont(name: bottomFontName, size: 150) ?? UIFont.systemFont(ofSize: 100)
        
        //4 - create a centered paragraph style
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        
        //5 - wrap that in attributed strings with the user's colors
        let topTextAttributes: [NSAttributedStringKey: Any]
            = [.foregroundColor: topColor, .font: topFont, .paragraphStyle: centered]
        let bottomTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: bottomColor, .font: bottomFont, .paragraphStyle: centered]
        
        //6 - start rendering at the correct size
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        
        postCard.image = renderer.image(actions:  { ctx in
            
            //fill the entire screen in gray
            UIColor.gray.set()
            ctx.fill(drawRect)
            
            //8 - draw the user's image at the top-left corner
            image?.draw(at: CGPoint(x: 0, y: 0))
            
            //9 - draw the top and bottom text
            topText.draw(in: topTextRect, withAttributes: topTextAttributes)
            bottomText.draw(in: bottomTextRect, withAttributes: bottomTextAttributes)
        })
        
        
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
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let color = colors[indexPath.item]
        let item = NSItemProvider(object: color)
        let dragItem = UIDragItem(itemProvider: item)
        return [dragItem]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        let location = session.location(in: postCard)
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            //handle text
            session.loadObjects(ofClass: NSString.self, completion: { (items) in
                guard let fontName = items.first as? String else {return}
                if location.y < self.postCard.bounds.midY {
                    self.topFontName = fontName
                } else {
                    self.bottomFontName = fontName
                }
                self.renderPostcard()
            })
            
            
        } else if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) {
            session.loadObjects(ofClass: UIImage.self, completion: { (items) in
                guard let draggedImage = items.first as? UIImage else {return}
                self.image = draggedImage
                self.renderPostcard()
            })
            
        }
    
        else {
            // handle color
            session.loadObjects(ofClass: UIColor.self, completion: { (items) in
                guard let color = items.first as? UIColor else {return}
                if location.y < self.postCard.bounds.midY {
                    self.topColor = color
                } else {
                    self.bottomColor = color
                }
                self.renderPostcard()
            })
        }
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let draggedImage = postCard.image else {return []}
        let itemProvider = NSItemProvider(object: draggedImage)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    

}

