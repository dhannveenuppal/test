//
//  CategoryModel.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import Foundation


struct Category{
    var id:String
    var name:String
    var image:String
}


func saveCategoryToFireStore()
{
    print("Saving all the Categories....")
  //  let id = UUID().uuidString
    
    let pet = Category(id: UUID().uuidString, name: "Pet Products", image: "pet")
    
    let men = Category(id: UUID().uuidString, name: "Men Fashion", image: "man")
    
    let Mfoot = Category(id: UUID().uuidString, name: "Men Footware", image: "shoes")
    
    let Ffoot = Category(id: UUID().uuidString, name: "Female FootWare", image: "shoes(1)")
    
    let electronics = Category(id: UUID().uuidString, name: "Electronics", image: "app")
    
    let sports = Category(id: UUID().uuidString, name: "Sports Goods", image: "ski")
    
    let beauty = Category(id: UUID().uuidString, name: "Beauty Products", image: "beauty")
    
    let household = Category(id: UUID().uuidString, name: "Household", image: "household")
    
    
    let arrayOfcategories = [pet,men,Mfoot,Ffoot,electronics,sports,beauty,household]
    
    
    for cat in arrayOfcategories{
        var catData:[String:Any] = ["catName":cat.name,"catImg":cat.image]
        
        FirebaseRef(.Category).addDocument(data: catData){
            (error) in
            if error != nil{
                print(error?.localizedDescription)
                
                print("Error Occured during Category Creation...")
            }
            else{
                print("\(cat) Category Created")
            }
            
        }
        
    }
    
}
