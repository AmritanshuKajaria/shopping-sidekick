//
//  ItemPageViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class ItemPageViewController: UIViewController {
    
        var isInList = true
    
    @IBOutlet weak var desiredPriceField: UITextField!
    
    @IBOutlet weak var realPrice: UILabel!
    
    @IBAction func changePriceButton(_ sender: Any) {
//        UsersDesiredPrice = desiredPriceField.text
    }
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func addAndRemoveButton(_ sender: UIButton) {
        if(isInList)
        {
            isInList = false
        }
        else
        {
            isInList = true
        }
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
