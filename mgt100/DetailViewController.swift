//
//  DetailViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/18/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var taHoursLabel: UILabel!
    var date: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = date
        
        // Do any additional setup after loading the view.
    }


}
