//
//  DetailedTAViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/19/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit

class DetailedTAViewController: UIViewController {
    
    
    @IBOutlet weak var taImage: UIImageView!
    @IBOutlet weak var taName: UILabel!
    @IBOutlet weak var hometown: UILabel!
    @IBOutlet weak var graduation: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var funFact: UILabel!
    
    var teachingName: String?
    var teachImage: String?
    var detailHometown: String?
    var detailGraduation: String?
    var detailMajor: String?
    var detailFunFact: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: teachImage!)
        let data = try? Data(contentsOf: url!)
        taImage.image = UIImage(data: data!)
        taName.text = teachingName
        
        hometown.text = detailHometown
        graduation.text = detailGraduation
        major.text = detailMajor
        funFact.text = detailFunFact
        
        

        // Do any additional setup after loading the view.
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
