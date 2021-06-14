//
//  SearchViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import Firebase
import  InstantSearchClient

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var resultID:[String] = []
    var itemArray:[Item] = []
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell

        cell.itemName.text = itemArray[indexPath.row].itemName

        cell.itemDesc.text = itemArray[indexPath.row].desc

        cell.price.text = String(itemArray[indexPath.row].price)

        cell.imgView.sd_setImage(with: URL(string: itemArray[indexPath.row].imgLinks[0]))
        
        
       // let cell =
        
        return cell
        
        
    }
    
    
    
    @IBAction func searchBTNClicked(_ sender: Any) {
        
        print("searching...")
        let index = AlgoliaService.shared.index
        
        let query = Query(query:searchText.text!)
        
        query.attributesToRetrieve = ["itemName","desc"]
        
        index.search(query) { (content, error) in
            if error != nil{
                print(error?.localizedDescription)
                print("Error duing searching ALgolia")
            }
            else
            {
                let cont = content!["hits"] as! [[String:Any]]
                self.resultID = []
                for res in cont {
                    self.resultID.append(res["objectID"] as! String)
                    
                }
                
                print(self.resultID)
                
                self.itemArray.removeAll()
              //  self.tableView.reloadData()
                
                FirebaseRef(.Items).getDocuments { (snapshot, error) in
                    if error != nil{
                                 print(error?.localizedDescription)
                                 print("Error duing searching Firebase")
                    }
                    else
                    {
                        if (snapshot?.documents.count)! > 0
                        {
                          //  print(snapshot?.documents.count)
                            for doc in snapshot!.documents{
                                let documentID = doc.documentID
                               // print(documentID)
                                if self.resultID.contains(documentID)
                                {
                                    if let imgData = doc.get("imgs") as? [String]{
                                        
                                        var newItem = Item(id: doc.documentID, itemName: doc.get("itemName") as! String, categoryID: doc.get("categoryID") as! String, desc:  doc.get("desc") as! String, price:  doc.get("price") as! Double, imgLinks:  imgData)
                                        
                                        //print(newItem)
                                                           
                                                                    
                                        self.itemArray.append(newItem)
                                    }
                                   // print(self.itemArray)
                                    self.tableView.reloadData()
                                }
                            }
                            //self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
}
