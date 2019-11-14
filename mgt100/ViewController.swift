//
//  ViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/13/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference().child("0")
        print("REFERENCE HERE")
        databaseHandle = ref.observe(.childAdded, with: { (data) in
       
            print(data)
        })
        
    }


}

