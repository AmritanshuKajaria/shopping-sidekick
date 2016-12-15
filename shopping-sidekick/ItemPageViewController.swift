//
//  ItemPageViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ItemPageViewController: UIViewController, UITextFieldDelegate {

    var asin = ""
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var highestLabel: UILabel!
    @IBOutlet weak var lowestLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var desiredPriceLabel: UILabel!
    
    @IBOutlet weak var desiredPrice: UITextField!
    
    @IBAction func removeItemButtonPressed(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            ref.child("items").child(asin).child("subscribedUsers").child(uid!).removeValue()
            ref.child("users").child(uid!).child("subscribedItems").child(self.asin).removeValue()
            
            performSegue(withIdentifier: "backSegue", sender: nil)
        }
    }
    
    @IBAction func addItemButtonPressed(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            let desiredPriceValue = self.desiredPrice.text
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            ref.child("items").child(asin).child("subscribedUsers").child(uid!).setValue(desiredPriceValue)
            ref.child("users").child(uid!).child("subscribedItems").child(self.asin).setValue(desiredPriceValue)
            
            performSegue(withIdentifier: "backSegue", sender: nil)
        }
    }
    
    @IBAction func updateItemButtonPressed(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            let desiredPriceValue = self.desiredPrice.text
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            ref.child("items").child(asin).child("subscribedUsers").child(uid!).setValue(desiredPriceValue)
            ref.child("users").child(uid!).child("subscribedItems").child(self.asin).setValue(desiredPriceValue)
            
            performSegue(withIdentifier: "backSegue", sender: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.isHidden = false
        self.removeButton.isHidden = true
        self.updateButton.isHidden = true
        self.desiredPriceLabel.isHidden = true
        
        
        self.desiredPrice.delegate = self
        
        if FIRAuth.auth()?.currentUser != nil {
            
            let user = FIRAuth.auth()?.currentUser
            let uid = user?.uid
            
            var ref: FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            ref.child("users").child(uid!).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item details
                let value = snapshot.value as? NSDictionary
                
                if value != nil
                {
                    for subscribedAsin in value!{
                        let tmpAsin = subscribedAsin.key as! String
                        let tmpVal = subscribedAsin.value as! String
                        if( tmpAsin == self.asin)
                        {
                            self.addButton.isHidden = true
                            self.removeButton.isHidden = false
                            self.updateButton.isHidden = false
                            self.desiredPriceLabel.isHidden = false
                            self.desiredPriceLabel.text = tmpVal
                            break
                        }
                    }
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
            ref.child("items").child(asin).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get item details
                let value = snapshot.value as? NSDictionary
                
                if value != nil
                {
                    let title = value?["title"] as? String ?? ""
                    let current_value = value?["current_value"] as? String ?? ""
                    let highest_value = value?["highest_value"] as? String ?? ""
                    let lowest_value = value?["lowest_value"] as? String ?? ""
                    let avg = value?["avg"] as? String ?? ""
                    let imageName = value?["image"] as? String ?? ""
                    
                    self.titleLabel.text = title
                    
                    
                    
                    self.currentLabel.text = String(format: "%.2f", (current_value as NSString).doubleValue)
                    //(someDouble.format(someDoubleFormat))
                    self.highestLabel.text = String(format: "%.2f", (highest_value as NSString).doubleValue)
                    self.lowestLabel.text = String(format: "%.2f", (lowest_value as NSString).doubleValue)
                    self.avgLabel.text = String(format: "%.2f", (avg as NSString).doubleValue)
                    
                    let imageUrl = "https://images-na.ssl-images-amazon.com/images/I/" + imageName
                    
                    let url = NSURL(string:imageUrl)
                    let data = NSData(contentsOf:url! as URL)
                    if data != nil {
                        self.itemImage.image = UIImage(data:data! as Data)
                         self.itemImage.contentMode = .scaleAspectFit
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        
        }
    }
    
    
    //Textfield delegates
   /* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            var decimalCount = 0
            for character in (textField.text?.characters)! {
                if character.description == "." {
                    decimalCount += 1
                }
                
            }
            
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = NSMutableArray()
            array.add(string)
            if array.count == 0 {
                return true
            }
            return false
        }
    }*/
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
