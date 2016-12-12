//
//  Item.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/11/16.
//  Copyright © 2016 Amritanshu Kajaria. All rights reserved.
//

import UIKit
//import FirebaseDatabase
//import FirebaseAuth

class Item: NSObject {
    
    
    
    
//    func getUsersItem() -> NSMutableArray
//    {
//        
//        var ref: FIRDatabaseReference!
//        
//        let res = NSMutableArray()
//        ref = FIRDatabase.database().reference()
//        
//        
//        
//        let userID = FIRAuth.auth()?.currentUser?.uid
//        ref.child("users").child(userID!).child("subscribedItems").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            
//            print(value ?? "")
//            
//            
//            
//            // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        
//        return res
//
//    }
    
    
//    var ASIN:String
//    
//    var avg:double
//    
//    var currenTimestamp:String
//    var currentValue:double
//    
//    var highestTimestamp:String
//    var highestValue:double
//    
//    var lowestTimestamp:String
//    var lowestValue:double
//    
//    var insertedTimestamp:String
//    var lastUpdatedTimestamp:String
//    
//    var priceTrend:int
//    
//    var subscribedUsers: NSMutableArray! = NSMutableArray()
//    
//    var title:String
//    var image:UIImage
    
    func getItem() -> NSMutableDictionary
    {        //find product in database, set properties for item, return object
        
        var itemDetails = NSMutableDictionary()
        itemDetails["ASIN"] = "2ga97yag"
        itemDetails["avg"] = 193.13
//        currenTimestamp = "1481102880"
//        currentValue = 99.99
//        
//        highestTimestamp = "1431045960"
//        highestValue = 219.85
//        
//        lowestTimestamp = "1473822960"
//        lowestValue = 7.7
//        
//        insertedTimestamp = "1481062184553"
//        lastUpdatedTimestamp = "1481062184553"
//        
//        priceTrend = 1;
//        
//        subscribedUsers.add("HADJ9N2D9AJ")
//        
//        title = "Soma Sustainable Carafe & Plant-Based Water Filter"
//        image = UIImage(named: "img_193292.jpg")

        return itemDetails
    }
    
}
