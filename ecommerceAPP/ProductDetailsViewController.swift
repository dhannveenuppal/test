//
//  ProductDetailsViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD
import Firebase

class ProductDetailsViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    
    var selectedItem:Item!
    
    var itemInBasket :[String] = []
    
    var hud = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        itemName.text = selectedItem.itemName
        price.text = "Price : $ \(String(selectedItem.price))"
        itemDesc.text = selectedItem.desc
        imgView.sd_setImage(with: URL(string: selectedItem.imgLinks[0]))
        
    }
    

    @IBAction func addToBasketClicked(_ sender: Any) {
        
        FirebaseRef(.Basket).whereField("ownerID", isEqualTo: Auth.auth().currentUser?.uid).getDocuments { (snapshot, error) in
            if (snapshot?.documents.count)! > 0
            {
                if let itemID = snapshot?.documents.first?.get("itemID") as? [String]{
                    self.itemInBasket = itemID
                    self.updateBasket(docID: String((snapshot?.documents.first!.documentID)!))
                }
            }
            else
            {
                self.addTobasket()
            }
        }
        
        
    }
    
    
    func addTobasket()
    {
        let itemData:[String:Any]=[
               
                   "ownerID":Auth.auth().currentUser?.uid,
                   "itemID":[selectedItem!.id]
               
               ]
               
               FirebaseRef(.Basket).addDocument(data: itemData) {
                   (error) in
                   if error != nil
                   {
                       print(error?.localizedDescription)
                       print("Error in Adding Items to Basket")
                   }
                   else{
                   self.hud.textLabel.text="Item Added"
                       self.hud.indicatorView = JGProgressHUDIndicatorView()
                       self.hud.show(in:self.view)
                       self.hud.dismiss(afterDelay: 2)
                   }
               }
    }
    
    
    func updateBasket(docID:String)
    {
        itemInBasket.append(selectedItem.id)
        
        let itemData:[String:Any]=[
        
            "ownerID":Auth.auth().currentUser?.uid,
            "itemID":itemInBasket
        
        ]
        
        FirebaseRef(.Basket).document(docID).updateData(itemData) {
            (error) in
            if error != nil
            {
                print(error?.localizedDescription)
                print("Error in updating Items to Basket")
            }
            else{
            self.hud.textLabel.text="Item Added and basket Updated"
                self.hud.indicatorView = JGProgressHUDIndicatorView()
                self.hud.show(in:self.view)
                self.hud.dismiss(afterDelay: 2)
            }
        }
        
    }
    
    
    
}
