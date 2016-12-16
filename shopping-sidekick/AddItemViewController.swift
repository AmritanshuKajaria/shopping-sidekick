//
//  AddItemViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    var searchResult = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchField.delegate = self
    }
    
    @IBAction func changeTextButton(_ sender: Any) {
        
        let searchTerm = searchField.text!
        searchField.text = nil
        print(searchTerm)
        
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        
        let cleanSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let full_url = "https://api.keepa.com/search?key=8fdnui1hbe9d62tc5npkmpgkdsaugfoui8ranves3sj5roe3tj1cfj5fggnbqtoo&domain=1&type=product&term="+cleanSearchTerm!
        
        let url = URL(string: full_url)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        let j = json as! NSMutableDictionary
                        
                        
                        
                        let products = j["products"] as! NSArray
                        
                        
                        
                        for product in products
                        {
                            let p = product as! NSDictionary
                            let productStats = self.processItem(keepa_item_data: p)
                            print(productStats)
                            let item = NSMutableDictionary()
                            item["asin"] = p["asin"]

                            item["title"] = p["title"]
                            item["image"] = p["imagesCSV"]
                            
                            item["avg"] = productStats["avg"]
                            item["price_change"] = productStats["price_change"]
                            item["current_timestamp"] = productStats["current_timestamp"]
                            item["current_value"] = productStats["current_value"]
                            item["highest_timestamp"] = productStats["highest_timestamp"]
                            item["highest_value"] = productStats["highest_value"]
                            item["lowest_timestamp"] = productStats["lowest_timestamp"]
                            item["lowest_value"] = productStats["lowest_value"]
                            
                            
                            
                            print(item)
                            self.searchResult.add(item)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("indexPath => " +  String(describing: indexPath))
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath as IndexPath) as! SearchResultsTableViewCell
        let itemDetails = (self.searchResult.object(at: indexPath.row) as AnyObject)
        //cell.textLabel?.text = itemDetails["title"] as? String
       
        cell.productName?.text = itemDetails["title"] as? String
        cell.productPrice?.text = itemDetails["current_value"] as? String
        print(itemDetails["current_value"] as? String)
        var imageName = itemDetails["image"] as! String
        let imageUrl = "https://images-na.ssl-images-amazon.com/images/I/" + imageName
        
        let url = NSURL(string:imageUrl)
        let data = NSData(contentsOf:url! as URL)
        if data != nil {
            cell.productImage.image = UIImage(data:data! as Data)
            cell.productImage.contentMode = .scaleAspectFit
        }
        return cell //BACKUP
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetails = (self.searchResult.object(at: indexPath.row) as AnyObject)
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
//        let avg = "" + itemDetails["avg"] as! String
        
        
//        var avgString =

        
        
        
        ref.child("items").child(itemDetails["asin"] as! String).child("title").setValue(itemDetails["title"] ?? "")
        ref.child("items").child(itemDetails["asin"] as! String).child("image").setValue(itemDetails["image"] ?? "")
        ref.child("items").child(itemDetails["asin"] as! String).child("avg").setValue( "\(itemDetails["avg"] as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("price_change").setValue( "\(itemDetails["price_change"] as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("current_timestamp").setValue( "\(itemDetails["current_timestamp"] as! Int)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("current_value").setValue( "\(itemDetails["current_value"] as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("highest_timestamp").setValue( "\(itemDetails["highest_timestamp"] as! Int)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("highest_value").setValue( "\(itemDetails["highest_value"] as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("lowest_timestamp").setValue( "\(itemDetails["lowest_timestamp"] as! Int)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("lowest_value").setValue( "\(itemDetails["lowest_value"] as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("inserted_timestamp").setValue( "\(NSDate().timeIntervalSince1970 as! Double)" )
        ref.child("items").child(itemDetails["asin"] as! String).child("last_updated_timestamp").setValue( "\(NSDate().timeIntervalSince1970 as! Double)" )
        
        
        performSegue(withIdentifier: "itemDetailSegue", sender: itemDetails["asin"] ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetailSegue"{
            let ItemInfoPage:ItemPageViewController = segue.destination as! ItemPageViewController
            ItemInfoPage.asin = sender as! String
        }
    }
    
    
    
    func processItem(keepa_item_data:NSDictionary) -> NSMutableDictionary {
        print("IN processItem")
        let data = keepa_item_data["csv"] as! NSArray
        let amz_data = convertToDict(keepa_data_list: data[0] as! NSArray)
        let new_data = convertToDict(keepa_data_list: data[1] as! NSArray)
        let amz_new_data = mergeTwoDict(dictOne: amz_data, dictTwo: new_data)
        let res = getLowestHighestAvg(keepa_data_dict: amz_new_data)
        return res
    }
    
    func convertToDict(keepa_data_list:NSArray) -> NSMutableDictionary {
        print("IN convertToDict")
        let res_dict = NSMutableDictionary()
        var isTime = 1
        var timevalue = 0
        for element in keepa_data_list{
            let e = element as! Double
            if isTime == 1{
                timevalue = element as! Int
                isTime = 0
            }else{
                let unixTime = (timevalue+21564000)*60
                res_dict[unixTime] = e/100.00
                isTime = 1
            }
        }
        return res_dict
    }
    
    func mergeTwoDict(dictOne:NSMutableDictionary, dictTwo:NSMutableDictionary) -> NSMutableDictionary {
        print("IN mergeTwoDict")
        var res_dict = NSMutableDictionary()
        res_dict = dictOne
        
        for element in dictTwo{
            let key = element.key
            let v = element.value as! Double
            if v > 0 {
                if res_dict[key] != nil{
                    let vTwo = dictTwo[key] as! Double
                    let vOne = res_dict[key] as! Double
                    if vTwo < vOne {
                        res_dict[key] = dictTwo[key]
                    }
                }
                else{
                    res_dict[key] = dictTwo[key]
                }
                
            }
            
        }
        return res_dict
    }
    
    func getLowestHighestAvg(keepa_data_dict:NSMutableDictionary) -> NSMutableDictionary {
        print("IN getLowestHighestAvg")
        var highest_value = 0.00
        var highest_timestamp = 0
        var lowest_value = 0.00
        var lowest_timestamp = 0
        var latest_value = 0.00
        var latest_timestamp = 0
        var second_latest_value = 0.00
        var second_latest_timestamp = 0

        var avg = 0.00
        var price_change = 0.00
        var cnt = 0.00
        var total = 0.00
        var first = true
        
        for time_entry in keepa_data_dict {
            var vaule = time_entry.value as! Double
            var time_entry_vaule = time_entry.key as! Int
            if vaule > 0 {
                cnt += 1
                total += Double(vaule)
                if first == true{
                    highest_value = Double(vaule)
                    lowest_value = Double(vaule)
                    latest_value = Double(vaule)
                    second_latest_value = Double(vaule)
                    highest_timestamp = time_entry.key as! Int
                    lowest_timestamp = time_entry.key as! Int
                    latest_timestamp = time_entry.key as! Int
                    second_latest_timestamp = time_entry.key as! Int
                    first = false
                } else {
                    if Double(vaule) > highest_value {
                        highest_value = Double(vaule)
                        highest_timestamp = time_entry.key as! Int
                    }
                    if Double(vaule) < lowest_value {
                        lowest_value = Double(vaule)
                        lowest_timestamp = time_entry.key as! Int
                    }
                    if time_entry_vaule > Int(latest_timestamp) {
                        latest_value = Double(vaule)
                        latest_timestamp = time_entry.key as! Int
                    }
                    if (time_entry_vaule > Int(second_latest_timestamp)) && (time_entry_vaule < Int(latest_timestamp)) && (Double(vaule) != latest_value) {
                        second_latest_value = Double(vaule)
                        second_latest_timestamp = time_entry.key as! Int
                    }
                    
                    
                }
            }
            
        }
        avg = total/cnt
        price_change = latest_value - second_latest_value
        
        let resDic = NSMutableDictionary()
        resDic["avg"] = avg
        resDic["price_change"] = price_change
        resDic["current_value"] = latest_value
        resDic["current_timestamp"] = latest_timestamp
        resDic["lowest_value"] = lowest_value
        resDic["lowest_timestamp"] = lowest_timestamp
        resDic["highest_value"] = highest_value
        resDic["highest_timestamp"] = highest_timestamp
        
        return resDic
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
