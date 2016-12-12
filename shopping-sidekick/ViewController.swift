//
//  ViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseDatabase


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    //This is a test
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    let itemDetailsList = NSMutableArray()
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        FBSDKAccessToken.setCurrent(nil)
        
        let mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginView")
        self.present(loginViewController, animated:true, completion:nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let name = user?.displayName
            let uid = user?.uid
            
            self.welcomeLabel.text = "Welcome " + name!
            
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            
            ref.child("users").child(uid!).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                for item in value!
                {
                    ref.child("items").child(item.key as! String ).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let itemDetails = snapshot.value as? NSMutableDictionary
                        self.itemDetailsList.add(itemDetails as Any)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDetailsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let itemDetails = (self.itemDetailsList.object(at: indexPath.row) as AnyObject)
        cell.textLabel?.text = itemDetails["title"] as? String
        return cell //BACKUP
    }
    var cellItem:String = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemDetails = (self.itemDetailsList.object(at: indexPath.row) as AnyObject)
        print(itemDetails)
        self.cellItem = (itemDetails["title"] as? String)!
        print("self.cellItem = > " + self.cellItem)
        super.performSegue(withIdentifier: "resultsSegue", sender: self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("I am here, HI ")
        let ItemInfoPage:ItemPageViewController = segue.destination as! ItemPageViewController
        ItemInfoPage.myASIN = (self.cellItem as? String)!
        print("myASIN => " + ItemInfoPage.myASIN)
        
    }
}



    




