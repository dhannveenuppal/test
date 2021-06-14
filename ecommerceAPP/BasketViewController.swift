//
//  BasketViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class BasketViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLBL: UILabel!
    
    
    var itemsInBasket:[Item] = []
    var itemID:[String] = []
    
    var hud = JGProgressHUD(style: .dark)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        getBasketInfoFromFirebase()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let deletedItemID = itemsInBasket[indexPath.row].id
            var count = 0
            
            var copyofItemID : [ String] = []
            
            copyofItemID.append(contentsOf: itemID)
            
            for id in itemID{
                if id == deletedItemID{
                    copyofItemID.remove(at: count)
                    break
                }
                count += 1
            }
            
            
            FirebaseRef(.Basket).whereField("ownerID", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    print("Error in Deletion the Basket")
                }
                else
                {
                    if (snapshot?.documents.count)! > 0
                    {
                        let docID = snapshot?.documents.first?.documentID
                        let itemData :[String:Any] = [
                        "ownerID":Auth.auth().currentUser?.uid,
                        "itemID":copyofItemID
                        ]
                        
                        FirebaseRef(.Basket).document(docID!).updateData(itemData){
                            (error) in
                            if error != nil {
                                               print(error?.localizedDescription)
                                               print("Error in Deletion the Basket")
                                           }
                            else
                            {
                                self.hud.textLabel.text = "Item Deleted and Basket Updated"
                                self.hud.indicatorView = JGProgressHUDIndicatorView()
                                self.hud.show(in: self.view)
                                self.hud.dismiss(afterDelay: 2)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasketTableViewCell
              
        cell.itemNAme.text = itemsInBasket[indexPath.row].itemName
        cell.itemDesc.text = itemsInBasket[indexPath.row].desc
        cell.price.text = String(itemsInBasket[indexPath.row].price)
       
        cell.imgView.sd_setImage(with: URL(string: itemsInBasket[indexPath.row].imgLinks[0]))
        
               return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInBasket.count
    }
    

    @IBAction func checkOutClicked(_ sender: Any) {
    }
    
    
    func getBasketInfoFromFirebase()
    {
        var totalPrice:Double = 0
        
        FirebaseRef(.Basket).whereField("ownerID", isEqualTo: Auth.auth().currentUser?.uid).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
                print("Error in Fetching the basket Items")
            }
            else
            {
                if let data = snapshot?.documents.first?.get("itemID") as? [String]
                {
                    self.itemID = data
                    self.itemsInBasket.removeAll()
                    
                    totalPrice = 0
                    
                    
                    for id in self.itemID{
                        FirebaseRef(.Items).document(id).getDocument { (documents, error) in
                           if error != nil {
                            print(error?.localizedDescription)
                            print("Error in Fetching the basket Items")
                            }
                            else
                            {
                                if let img = documents?.get("imgs")! as? [String]
                                {
                                    let newItem = Item(id: (documents?.documentID as? String)!, itemName: (documents?.get("itemName") as? String)!, categoryID: (documents?.get("categoryID") as? String)!, desc: (documents?.get("desc") as? String)!, price: (documents?.get("price") as? Double)!, imgLinks: img)
                                    
                                    let price = documents?.get("price") as? Double
                                    totalPrice = totalPrice + price!
                                    
                                    self.itemsInBasket.append(newItem)
                                    self.tableView.reloadData()
                                    self.totalLBL.text = "Total : $ \(totalPrice)"
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
