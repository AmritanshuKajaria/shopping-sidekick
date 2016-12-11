//
//  ItemPageViewController.swift
//  test-test
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class ItemPageViewController: UIViewController {

    
    @IBOutlet weak var productLabel: UILabel!
    var productString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if productLabel != nil {
            self.productLabel.text = self.productString
        }
        
    }

    

   
}
