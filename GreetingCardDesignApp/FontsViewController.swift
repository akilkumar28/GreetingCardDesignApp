//
//  FontsViewController.swift
//  GreetingCardDesignApp
//
//  Created by AKIL KUMAR THOTA on 12/16/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MobileCoreServices

class FontsViewController: UITableViewController,UITableViewDragDelegate {
    
    
    
    
    let fonts = UIFont.familyNames.sorted()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragDelegate  = self
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = fonts[indexPath.row]
        cell.textLabel?.font = UIFont(name: fonts[indexPath.row], size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let font = fonts[indexPath.row]
        guard let fontData = font.data(using: .utf8) else {return []}
        let itemProvider = NSItemProvider(item: fontData as NSData, typeIdentifier: kUTTypePlainText as String)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    

}
