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
    var result:String!
    
    func addItemToUserList(asin:String , desiredPrice:Decimal) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            let key = ref.child("users").child(uid!).child("subscribedItems").child(asin)
            key.setValue(desiredPrice)
            
            let itemKey = ref.child("items").child(asin).child("subscribedUsers").child(uid!)
            itemKey.setValue(true)
            
        }
    }
    
    func storeItem(asin:String, data:NSMutableDictionary, desiredPrice:Decimal) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            print(data)
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            
            let current_data = data["current"] as! NSMutableDictionary;
            let current = ["timestamp":current_data["timestamp"],
                           "value":current_data["value"]]
            
            let lowest_data = data["lowest"] as! NSMutableDictionary;
            let lowest = ["timestamp":lowest_data["timestamp"],
                          "value":lowest_data["value"]]
            
            let highest_data = data["highest"] as! NSMutableDictionary;
            let highest = ["timestamp":highest_data["timestamp"],
                           "value":highest_data["value"]]
            
            let users = NSMutableDictionary();
            users[uid] = true
            
            let item_data = ["title": data["title"],
                             "image": data["image"],
                             "avg": data["avg"],
                             "current": current,
                             "lowest": lowest,
                             "highest": highest,
                             "price_change": data["price_change"],
                             "inserted_timestamp" : NSDate().timeIntervalSince1970
            ]
            
            let key = ref.child("items").child(asin)
            key.setValue(item_data)
            addItemToUserList(asin: asin, desiredPrice: desiredPrice)

        }
    }
    
    let itemDetailsList = NSMutableArray()
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
//            
//            let dataTmp = NSMutableDictionary()
//            let current_data = NSMutableDictionary()
//            
//            current_data["timestamp"] = "1481526197"
//            current_data["value"] = "11.11"
//            
//            dataTmp["title"] = "Test title"
//            dataTmp["image"] = "Test Image"
//            dataTmp["avg"] = 10.10
//            dataTmp["current"] = current_data
//            dataTmp["lowest"] = current_data
//            dataTmp["highest"] = current_data
//            dataTmp["price_change"] = 0
//            
//            storeItem(asin: "ZZZZZZZ", data:dataTmp, desiredPrice: 10.53 )
            
            
            
//            addItemToUserList(asin: "B00LAX52IZ", desiredPrice: 10.63)
            
            
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
                            // Get user value
                            let itemDetails = snapshot.value as? NSMutableDictionary
                            
//                            print(itemDetails)
                            
                            
                            
                            self.itemDetailsList.add(itemDetails as Any)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                            
                            
                            print(itemDetails ?? "")
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                print("Printing List")
                print(itemDetailsList)
                
            }
            
//            self.tableView.reloadData()
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        }
    
  
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return self.itemDetailsList.count
//            return 1getUserItems(UID).count;
        }
    
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
            
//            let itemList = getUserItems(UID)
          
//            let item = itemList[indexPath.row]
            
//            item["ASIN"]
//            item["title"]
//            
//            var newItem = Item()
//            let itemDetails = newItem.getItem()
            
            let itemDetails = (self.itemDetailsList.object(at: indexPath.row) as AnyObject)
            
            cell.textLabel?.text = itemDetails["title"] as! String
            
//            print(cell.textLabel?.text)
            return cell //BACKUP
            
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
//            self.result = itemDetails["ASIN"] as! String
//
//            print(self.result)
            
            
            self.performSegue(withIdentifier: "resultsSegue", sender: self)
            
        }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
          }
    
    
}



    




