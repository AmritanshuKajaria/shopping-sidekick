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
    
    
    
//    func getUserItems(UID:String) -> NSMutableArray{
//
//        var itemList = NSMutableArray()
//        itemList.add("ASIN1")//TODO replace with data from database
//        itemList.add("ASIN2")//TODO replace with data from database
//        itemList.add("ASIN3")//TODO replace with data from database
//        return itemList
//    }
    
//    func getItemDetails(ASIN:String) -> NSMutableDictionary{
//
//        var itemDetails = NSMutableDictionary()
//        itemDetails["ASIN"] = ASIN //TODO replace with data from database
//        itemDetails["avg"] = 193.13 //TODO replace with data from database
//        itemDetails["highest"] = 1913.13 //TODO replace with data from database
//        itemDetails["lowest"] = 3.13 //TODO replace with data from database
//        itemDetails["yesterday"] = 242 //TODO replace with data from database
//        itemDetails["today"] = 13.13 //TODO replace with data from database
//        
//        return itemDetails
//        
//    }
    
//    func getUsersItem() -> NSMutableArray
//    {
//
//        
//    }
    
        
//        
////
////            print("hi")
////            print(value)
////
////            for item in value!{
////                
////                print(item.key)
////                
////                var asin = String(_ describing: item.key) as? String
////                
////                
////                
////                
////                let res = getItemDetails(asin)
////                print(res)
////                
////                
////            }
//            
////            print(value ?? "")
////
////            
////            let items = value?.allKeys
////            
////            var cnt = 1
////            for item in items!
////            {
////                //var asin = String(describing: item)
////                var asin:String = item as! String
////                
////                
////                let v = "" + String(asin)
////                
////                print(v)
////                
////                
////                getItemDetails(v)
////                
////                
////                
////                
////                
////                
////                
////                
////                
////                
////                
////                print(String(cnt) + " ) " + String(describing: item))
////                cnt += 1
////            }
////            
////            
//            
//            // ...
////        }) { (error) in
////            print(error.localizedDescription)
////        }
////        
//        return res
//    }
//    
//    func getItemDetails(asin:String) -> NSMutableDictionary
//    {
//        var itemDetails = NSMutableDictionary()
//        
//        var ref: FIRDatabaseReference!
//        let res = NSMutableArray()
//        ref = FIRDatabase.database().reference()
//        
//        
//        ref.child("items").child(asin).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSMutableDictionary
//            print(value!); print("IT WOKED")
//            
//            itemDetails = value!
//            
////            print("I am here")
//            
////            print(value!)
//            
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        
//
//        
//    return value
//    }
//    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            if FIRAuth.auth()?.currentUser != nil {
                
                let user = FIRAuth.auth()?.currentUser
                let name = user?.displayName
                let uid = user?.uid
                
                self.welcomeLabel.text = "Welcome " + name!
                
                
                let itemDetailsList = NSMutableArray()
                
                var ref: FIRDatabaseReference!
                ref = FIRDatabase.database().reference()
                
                
                ref.child("users").child(uid!).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    for item in value!
                    {
                        ref.child("items").child(item.key as! String ).observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let itemDetails = snapshot.value as? NSMutableDictionary
                            
                            itemDetailsList.add(itemDetails as Any)
                            
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
            
            

            
            
//            let items = getUserItems("asja")
            
//            for item in items{
//                
//                itemDetailsList.add(getItemDeatils(item))
//                
//            }
            
            self.tableView.reloadData()
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        }
    
  
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int
        {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return 1
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
////            let itemDetails = (self.array1.object(at: indexPath.row) as AnyObject).getItem()
            
//            cell.textLabel?.text = itemDetails["ASIN"] as! String
            
//            print(cell.textLabel?.text)
            return cell //BACKUP
            
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
//            self.result = itemDetails["ASIN"] as! String
//
//            print(self.result)
//            self.performSegue(withIdentifier: "resultsSegue", sender: self)
            
        }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
          }
    
    
}



    




