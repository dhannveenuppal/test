//
//  ProductListViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class ProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    var selectedCategory:Category!
    
    
    var allProducts:[Item] = []

    @IBOutlet weak var productTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadItems()
        productTableView.delegate = self
        productTableView.dataSource = self
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductListTableViewCell
        
            cell.itemName.text = allProducts[indexPath.row].itemName
         cell.itemDesc.text = allProducts[indexPath.row].desc
         cell.price.text = String(allProducts[indexPath.row].price)
        
            cell.imgView.sd_setImage(with: URL(string: self.allProducts[indexPath.row].imgLinks[0]))
    
        
         return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToProductDetailsVC", sender: allProducts[indexPath.row])
    }
    
    
    
    
    
    @IBAction func addProductClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toAddProductVC", sender: selectedCategory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddProductVC" {
            let vc = segue.destination as! AddProductViewController
            vc.category = sender as! Category
        }
        
        else if segue.identifier == "ToProductDetailsVC" {
            let vc = segue.destination as! ProductDetailsViewController
            vc.selectedItem = sender as! Item
        }
        
        
        
        
    }
    
     func loadItems()
      {
          FirebaseRef(.Items).whereField("categoryID", isEqualTo: selectedCategory.id).getDocuments { (snapshot, error) in
              if error != nil{
                  print(error?.localizedDescription)
                  print("Error in Fetching Items from Firebase")
              }
              else{
                  for doc in snapshot!.documents{
                    
                    
                      var newItem = Item(id: doc.documentID, itemName: doc.get("itemName") as! String, categoryID: doc.get("categoryID") as! String, desc:  doc.get("desc") as! String, price:  doc.get("price") as! Double, imgLinks:  doc.get("imgs") as! [String])
                    
                      
                      self.allProducts.append(newItem)
                  }
                   // print(self.allProducts[0])
                  self.productTableView.reloadData()
              }
          }
      }
    
    
    

}
