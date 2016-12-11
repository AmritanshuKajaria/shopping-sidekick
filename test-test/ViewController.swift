//
//  ViewController.swift
//  test-test
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    //This is a test
    @IBOutlet weak var tableView: UITableView!
    
    var result:String!
    
    var array1: NSMutableArray! = NSMutableArray()
    
        override func viewDidLoad() {
            super.viewDidLoad()
           
            self.array1.add("First")
            self.array1.add("Second")
            self.array1.add("Third")
            self.array1.add("Third")
            
            self.tableView.reloadData()
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            

        }
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.array1.count;
        }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
           /* let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableViewCell

            cell.productLabel.text = self.array1.object(at: indexPath.row) as? String
            
            cell.productButton.tag = indexPath.row;
            cell.productButton.addTarget(self, action: "logAction:", for: .touchUpInside)
            
            return cell*/
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
            
            
            cell.textLabel?.text = self.array1.object(at: indexPath.row) as? String
            
            return cell //BACKUP
            
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            /*let alertController = UIAlertController(title: "Something", message: "bla bla", preferredStyle: UIAlertControllerStyle.alert)

            
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true)*/

            
            //print("You selected cell #\(indexPath.row)!")
            //print(array1.object(at: indexPath.row))
            self.result = self.array1.object(at: indexPath.row) as? String
            print(self.result)
            self.performSegue(withIdentifier: "resultsSegue", sender: self)
           // self.performSegue(withIdentifier: "showView", sender: self)

            
        }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "resultsSegue"{
            let destinationVC = segue.destination as! ItemPageViewController
            
            
            
            //destinationVC.productLabel = self.result as? String
        }
        
    }
    
    
}



    




