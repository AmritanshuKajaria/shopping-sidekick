//
//  ItemPageViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class ItemPageViewController: UIViewController {
    
    
    let someShit = true
    
    @IBAction func addAndRemoveButton(_ sender: UIButton) {
        if(someShit)
        { sender.setTitle("Remove From List", for: .normal) }
        else
        { sender.setTitle("Add To List", for: .normal) }
    }
    @IBOutlet weak var productLabel: UILabel!
    var productString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if productLabel != nil {
            self.productLabel.text = self.productString
        }
        
    }
    
    
    
    
}
