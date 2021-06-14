//
//  firebaseRef.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import Foundation
import Firebase


enum FirebaseCollectionRef : String{
    case Users
    case Items
    case Category
    case Basket
}


func FirebaseRef(_ collectionRef:FirebaseCollectionRef) -> CollectionReference{
    return Firestore.firestore().collection(collectionRef.rawValue)
}
