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
    @IBOutlet weak var taIMageView: UIView!
    
    
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        
        taIMageView.layer.shadowColor = UIColor.darkGray.cgColor
        taIMageView.layer.shadowRadius = 5
        taIMageView.layer.shadowOpacity = 0.5
        taIMageView.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        UIView.animate(withDuration: 0.4) {
            statusBar?.backgroundColor = UIColor(red: 57/255.0, green: 90/255.0, blue: 255/255.0, alpha: 1)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
//        UIView.animate(withDuration: 0.3) {
            statusBar?.backgroundColor = UIColor.white
//        }
    }
    
    
    @IBAction func goBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
