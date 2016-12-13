//
//  AddItemViewController.swift
//  shopping-sidekick
//
//  Created by Jason Gindi on 12/10/16.
//  Copyright © 2016 JasonGindi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    var searchResult = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                            let item = NSMutableDictionary()
                            item["title"] = p["title"]
                            item["asin"] = p["asin"]
                            item["image"] = p["imagesCSV"]
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let itemDetails = (self.searchResult.object(at: indexPath.row) as AnyObject)
        cell.textLabel?.text = itemDetails["title"] as? String
        return cell //BACKUP
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetails = (self.searchResult.object(at: indexPath.row) as AnyObject)
        
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        
        ref.child("items").child(itemDetails["asin"] as! String).child("title").setValue(itemDetails["title"] ?? "title")
        
        ref.child("items").child(itemDetails["asin"] as! String).child("image").setValue(itemDetails["imagesCSV"] ?? "31sf0VA5f5L.jpg")
        
        performSegue(withIdentifier: "itemDetailSegue", sender: itemDetails["asin"] ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemDetailSegue"{
            let ItemInfoPage:ItemPageViewController = segue.destination as! ItemPageViewController
            ItemInfoPage.asin = sender as! String
        }
    }
}
