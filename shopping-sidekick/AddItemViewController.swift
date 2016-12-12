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
    var searchResult = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        }
    
    @IBAction func changeTextButton(_ sender: Any) {
//        dummyLabel.text = searchField.text
        searchInput = searchField.text!
        print(searchInput)
        
        
        
        self.searchResult = searchItem(searchTerm: searchInput)
        
        print("search count => " + String(self.searchResult.count))
        searchField.text = nil
        
        print("searchResItemList =>")
        print(self.searchResult)
        
        
//        self.tableView.reloadData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResult.count;
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)

        let itemDetails = (self.searchResult.object(at: indexPath.row) as AnyObject)
        
        cell.textLabel?.text = itemDetails["title"] as? String
        
        //            print(cell.textLabel?.text)
        return cell //BACKUP
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.result = self.searchResults.object(at: indexPath.row) as? String
        //print(self.result)
      //  self.performSegue(withIdentifier: "resultsSegue", sender: self)
        
    }
    
    func searchItem(searchTerm:String) -> NSMutableArray   {
        let resItemList = NSMutableArray()
        
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
                        print("json =>")
                        print(json)
                        
                        print("json.count =>")
                        print(json.count)
                        
                        print("json.keys =>")
                        print(json.keys)
                        
                        let j = json as! NSMutableDictionary
                        
                        print("j =>")
                        print(j)
                        
                        print("j.count =>")
                        print(j.count)
                        
                        print("j.keys =>")
                        print(j.allKeys)
                        
                        let products = j["products"] as! NSArray
                        
                        print("products.count => ")
                        print(products.count)
                        
                        for product in products
                        {
                            let p = product as! NSDictionary
                            
                            let item = NSMutableDictionary()
                            item["title"] = p["title"]
                            item["asin"] = p["asin"]
                            item["image"] = p["imagesCSV"]
                            resItemList.add(item)
                            
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
        return resItemList
    }

    
    
    
}
