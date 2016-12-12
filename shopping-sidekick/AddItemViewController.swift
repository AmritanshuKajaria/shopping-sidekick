//
//  AddItemViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchField: UITextField!

    var searchInput:String = ""
    
    @IBOutlet weak var dummyLabel: UILabel!
    
    var searchResults: NSMutableArray! = NSMutableArray()

    @IBOutlet weak var tableView: UITableView!
   
    
    var array1 = ["1","2","3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        }
    
    @IBAction func changeTextButton(_ sender: Any) {
        dummyLabel.text = searchField.text
        searchInput = searchField.text!
        print(searchInput)
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        cell.textLabel?.text = array1[indexPath.row]
        
        //self.searchResults.object(at: indexPath.row) as? String
 
        
        return cell //BACKUP
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.result = self.searchResults.object(at: indexPath.row) as? String
        //print(self.result)
      //  self.performSegue(withIdentifier: "resultsSegue", sender: self)
        
    }

    
    
    
}
