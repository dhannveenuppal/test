//
//  AddProductViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import Firebase
import Gallery
import JGProgressHUD
import NVActivityIndicatorView
import InstantSearchClient

class AddProductViewController: UIViewController {

    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemDesc: UITextView!
    
    
    var gallery :GalleryController!
    var hud = JGProgressHUD(style:.dark)
    
    var activityIndicator : NVActivityIndicatorView?
    
    var ImageArray:[UIImage?] = []
    var ImageURLArray:[String] = []
    
    var category:Category?
    
    var docID=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(category)
    }
    @IBAction func cameraClicked(_ sender: Any) {
        showImageGallery()
    }
    
    @IBAction func saveProductClicked(_ sender: Any) {
        
        if ImageArray.count == 0{
            let itemData :[String:Any] = [
            "itemName":itemName.text!,
            "desc":itemDesc.text!,
            "price":Double(itemPrice.text!),
                "imgs":[],
                "categoryID":category?.id
            
            ]
            
            FirebaseRef(.Items).addDocument(data: itemData){
                (error) in
                if error != nil{
                    print(error?.localizedDescription)
                    print("Error in Adding Items")
                }
                else{
                    print("Item Added")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else
        {
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let mediaFolder = storageRef.child("images")
            
            
            for image in ImageArray{
                if let data = image?.jpegData(compressionQuality: 0.5){
                    let imageRef = mediaFolder.child("\(UUID()).jpeg")
                    imageRef.putData(data, metadata: nil)
                    {
                        (metadata,error) in
                        if error != nil {
                            print(error?.localizedDescription)
                            print("Error in Uploading Images")
                        }
                        else{
                            imageRef.downloadURL { (url, error) in
                                if error == nil{
                                    self.ImageURLArray.append(url!.absoluteString)
                                    print(self.ImageURLArray)
                                    
                                    if self.ImageURLArray.count == self.ImageArray.count{
                                        let itemData :[String:Any] = [
                                                   "itemName":self.itemName.text!,
                                                   "desc":self.itemDesc.text!,
                                                   "price":Double(self.itemPrice.text!),
                                                       "imgs":self.ImageURLArray,
                                                       "categoryID":self.category?.id
                                                   
                                                   ]
                                        
                                        self.docID = UUID().uuidString
                                        FirebaseRef(.Items).document(self.docID).setData( itemData){
                                                      (error) in
                                                      if error != nil{
                                                          print(error?.localizedDescription)
                                                          print("Error in Adding Items")
                                                      }
                                                      else{
                                                          print("Item Added")
                                                        
                                                        
                                                        let index = AlgoliaService.shared.index
                                                        let itemToSave :[String:Any] = [
                                                        "itemName":self.itemName.text!,
                                                        "desc":self.itemDesc.text
                                                        ]
                                                        
                                                        index.addObject(itemToSave, withID: self.docID, requestOptions: nil) { (content, error) in
                                                            if error != nil{
                                                                print(error?.localizedDescription)
                                                                print("Error in Posting  Items in Algolia")
                                                            }
                                                            else
                                                            {
                                                                print("Algolia Posted")
                                                            }
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                          self.navigationController?.popViewController(animated: true)
                                                      }
                                                  }
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
    
    private func showImageGallery()
    {
            self.gallery = GalleryController()
        self.gallery.delegate = self
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = 4
        
        self.present(self.gallery,animated: true,completion: nil)
    }
    
}


extension AddProductViewController:GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0{
            Image.resolve(images:images){
                (resolvedImg) in
                self.ImageArray = resolvedImg
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
