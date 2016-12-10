//
//  ViewController.swift
//  shopping-sidekick
//
//  Created by Amritanshu Kajaria on 12/7/16.
//  Copyright © 2016 Amritanshu Kajaria. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var colorLabel: UILabel!
    
    let colorRef = FIRDatabase.database().reference().child("color")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colorRef.observe(FIRDataEventType.value, with: { (snapshot) in
            self.colorLabel.text = snapshot.value as? String
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func redPressed(_ sender: UIButton) {
        print("Red Pressed!!")
        FIRAnalytics.logEvent(withName: "red_button_pressed", parameters: nil)
        colorRef.setValue("Red")
    }

    @IBAction func greenPressed(_ sender: UIButton) {
        print("Green Pressed!!")
        FIRAnalytics.logEvent(withName: "green_button_pressed", parameters: nil)
        colorRef.setValue("Green")
    }
    @IBAction func bluePressed(_ sender: UIButton) {
        print("Blue Pressed!!")
        FIRAnalytics.logEvent(withName: "blue_button_pressed", parameters: nil)
        colorRef.setValue("Blue")
    }
    
}

