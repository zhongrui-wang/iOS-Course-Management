//
//  ViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/13/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        let db = Firestore.firestore()
        
        //Getting from the months collection, the month of January
        let January = db.collection("months").document("January")
        
        //Reading all the documents (which are days) from the document January
        January.collection("days").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("January")
                for document in querySnapshot!.documents {
                    print("DAY: \(document.documentID)")
                    
                    //Getting all TAs as an array
                    print("Array of TAs")
                    if let tas = document.data()["tas"] as? NSArray {
                        print(tas)
                        //print("First TA: \(tas[0])")
                    }
                    
                    //Getting all Readings as an array
                    print("Array of readings")
                    if let readings = document.data()["readings"] as? NSArray {
                        print(readings)
                    }
                    
                    
                }
            }
        }
        
    }
}

