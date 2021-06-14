//
//  ViewController.swift
//  ecommerceAPP
//
//  Created by Akshay  on 12/01/20.
//  Copyright © 2020 Akshay . All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var usernameTXT: UITextField!
    @IBOutlet weak var passwordTXT: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //saveCategoryToFireStore()
    }

    @IBAction func loginClicked(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: usernameTXT.text!, password: passwordTXT.text!) { (result, error) in
            if error != nil{
                          print(error?.localizedDescription)
                          
                          print("Error in Signin")
                          
            }
            else
            {

                self.performSegue(withIdentifier: "toShopVC", sender: nil)
            }
        }
        
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        Auth.auth().createUser(withEmail: usernameTXT.text!, password: passwordTXT.text!) { (result, error) in
            if error != nil{
                print(error?.localizedDescription)
                
                print("Error in Signup")
                
            }
            else{
                let userData:[String:Any] =
                ["username":self.usernameTXT.text!,"email":self.usernameTXT.text!,"password":self.passwordTXT.text!,"uIdFromFirebase":result?.user.uid]
                
                FirebaseRef(.Users).addDocument(data: userData){
                    (error) in
                    if error != nil{
                                  print(error?.localizedDescription)
                                  
                                  print("Error in Signup")
                                  
                              }
                    else{
                        self.performSegue(withIdentifier: "toShopVC", sender: nil)
                    }
                }
            }
        }
    }
    
}

