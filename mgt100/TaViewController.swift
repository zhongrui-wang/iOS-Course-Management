//
//  TaViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/19/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import Firebase


class TaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    struct APIResults:Codable {
        let teaching_assistant: [Tas]
    }
    
    struct Tas:Codable {
        let level: String
        let tas: [TasDetail]
    }
    
    struct TasDetail: Codable {
        let name: String
        let graduation: String
        let image: String
        let major: String
        let minor: String
        let fun_fact: String
        let hometown: String
    }
    
    @IBOutlet weak var tableView: UITableView!
    var theTasData: APIResults?
    var theTaData: [Tas] = []

    override func viewDidLoad() {
        self.setUpTableView()
        super.viewDidLoad()
        self.grabFirebaseData()
        // Do any additional setup after loading the view.
    }
    
    func grabFirebaseData(){
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                self.theTasData = try JSONDecoder().decode(APIResults.self, from: jsonData)
            } catch let error {
                print(error)
            }
            
            for i in self.theTasData!.teaching_assistant{
                self.theTaData.append(i)
            }

            self.tableView.reloadData()
        })
    }
    
    func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.theTasData?.teaching_assistant[section].tas.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = String(self.theTaData[indexPath.section].tas[indexPath.row].name)
//             cell.textLabel?.text = "asdad"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.theTasData?.teaching_assistant.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.theTasData?.teaching_assistant[section].level
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedTAViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailedTAViewController") as! DetailedTAViewController
        
        detailedTAViewController.teachingName = String(self.theTaData[indexPath.section].tas[indexPath.row].name)
        detailedTAViewController.teachImage = String(self.theTaData[indexPath.section].tas[indexPath.row].image)
        
        detailedTAViewController.detailHometown = String(self.theTaData[indexPath.section].tas[indexPath.row].hometown)
        detailedTAViewController.detailGraduation = String(self.theTaData[indexPath.section].tas[indexPath.row].graduation)
        detailedTAViewController.detailMajor = String(self.theTaData[indexPath.section].tas[indexPath.row].major)
        detailedTAViewController.detailFunFact = String(self.theTaData[indexPath.section].tas[indexPath.row].fun_fact)
        
        self.navigationController?.pushViewController(detailedTAViewController, animated: true)
    }

}
