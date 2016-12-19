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
            
            self.welcomeLabel.text = "Welcome, " + name!
            
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            
            ref.child("users").child(uid!).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if (value != nil)
                {
                    for item in value!
                    {
                        ref.child("items").child(item.key as! String ).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let itemDetails = snapshot.value as? NSMutableDictionary
                            itemDetails?["asin"] = item.key as! String
                            self.itemDetailsList.add(itemDetails as Any)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        //self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
          }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemDetailsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! TableViewCell
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            let itemDetails = (self.itemDetailsList.object(at: indexPath.row) as AnyObject)
            
            cell.productName?.text = itemDetails["title"] as? String
            cell.productPrice?.text = itemDetails["current_value"] as? String

            let users_details = itemDetails["subscribedUsers"] as! NSDictionary
            print("HERE")
            let price = users_details[uid]
           cell.desiredPrice?.text = price as? String
            
            //if uid != "HelzbR0xfEdvERqV0LBqBpQT2kS2"
            //{
                let conf_details = users_details[uid] as! NSDictionary
                let dPrice = conf_details["desired_price"]
                cell.desiredPrice?.text = dPrice as? String
            //}

            let imageName = itemDetails["image"] as! String
            let imageUrl = "https://images-na.ssl-images-amazon.com/images/I/" + imageName
            
            let url = NSURL(string:imageUrl)
            let data = NSData(contentsOf:url! as URL)
            if data != nil {
                cell.productImage.image = UIImage(data:data! as Data)
                cell.productImage.contentMode = .scaleAspectFit
            }
          
            var difference = (itemDetails["price_change"] as! NSString).doubleValue
            if(difference > 0){

                cell.priceChangeArrow.image = UIImage(named: "red-arrow")
            }
            else if(difference < 0){
                cell.priceChangeArrow.image = UIImage(named: "green-arrow")
            }
        
        }
        
        return cell
    }
    var cellItem:String = ""
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetails = (self.itemDetailsList.object(at: indexPath.row) as AnyObject)
        performSegue(withIdentifier: "resultsSegue", sender: itemDetails["asin"] ?? "title")
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsSegue"{
            let ItemInfoPage:ItemPageViewController = segue.destination as! ItemPageViewController
            ItemInfoPage.asin = sender as! String
        }
    }
}



    




