//
//  AlgoliaService.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService{
    
    static let shared = AlgoliaService()
    
    
    
    let client = Client(appID: "VK4P0TL335", apiKey: "b17c6c9498dad112a4a95b89c98d5c52")
    
    let index = Client(appID: "VK4P0TL335", apiKey: "b17c6c9498dad112a4a95b89c98d5c52").index(withName: "item_name")
    
    
    private init()
    {
        
    }
    
}
