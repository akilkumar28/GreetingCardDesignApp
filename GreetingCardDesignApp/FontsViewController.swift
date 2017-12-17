//
//  FontsViewController.swift
//  GreetingCardDesignApp
//
//  Created by AKIL KUMAR THOTA on 12/16/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class FontsViewController: UITableViewController {
    
    
    let fonts = UIFont.familyNames.sorted()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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

}
