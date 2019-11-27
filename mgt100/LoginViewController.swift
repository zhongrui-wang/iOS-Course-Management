//
//  LoginViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/26/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = emailTextInput.text, let password = passwordTextInput.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "LoginToChat", sender: self)
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
