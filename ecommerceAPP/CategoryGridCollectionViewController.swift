//
//  CategoryGridCollectionViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import Firebase

class CategoryGridCollectionViewController: UICollectionViewController {
    
    var allCategories :[Category] = []
    
    let  sectionInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
      
      let numberPerRow:CGFloat = 3
    

    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategoryData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return allCategories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        cell.catLBL.text = allCategories[indexPath.row].name
        cell.imgView.image = UIImage(named: allCategories[indexPath.row].image)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToProductListVC", sender: allCategories[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToProductListVC" {
            let vc = segue.destination as! ProductListViewController
            vc.selectedCategory = sender as! Category
        }
    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        do{
                   try Auth.auth().signOut()
                  performSegue(withIdentifier: "toLoginVC", sender: nil)
               }
               catch{
                   print("Error in Signing Out")
               }
    }
    
    
    func loadCategoryData()
       {
           FirebaseRef(.Category).getDocuments { (snapshot, error) in
               if error != nil{
                   print(error?.localizedDescription)
                   print("Error in Fetching Categories from Firebase")
               }
               else{
                   for doc in snapshot!.documents{
                       var newCategory = Category(id: doc.documentID, name: doc.get("catName") as! String, image: doc.get("catImg") as! String)
                       
                       self.allCategories.append(newCategory)
                   }
                print(self.allCategories.count)
                   self.collectionView.reloadData()
               }
           }
       }

    

}

extension CategoryGridCollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = sectionInset.left * (numberPerRow+1)
        let available = view.frame.width - padding
        
        let widthPeritem = available / numberPerRow
        
        return CGSize(width: widthPeritem, height: widthPeritem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInset.left
    }
}


