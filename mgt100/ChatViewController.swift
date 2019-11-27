//
//  ChatViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/26/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Message"
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
//    

    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
            
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    

}
