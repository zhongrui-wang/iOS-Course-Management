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
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    struct APIResults:Codable {
        let results: [Months]
    }
    
    struct Months:Codable {
        let month: String
        let description: [MonthDetail]
    }
    
    struct MonthDetail: Codable {
        let assignments: [String]
        let readings: [String]
        let tas: [String]
        let date: Int!
    }
    
    
    var theFallData: APIResults?
    var theMonthData: [Months] = []
    var assignments: [String] = []
    var tas: [String] = []
    var readings: [String] = []
    var dateCellExpanded: Bool = false
    var expandedIndexpath = IndexPath()
    
    
    //Main table view
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.grabFirebaseData()
        self.setUpTableView()
    }
    
    func grabFirebaseData(){
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                self.theFallData = try JSONDecoder().decode(APIResults.self, from: jsonData)
            } catch let error {
                print(error)
            }
            
            for i in self.theFallData!.results{
                self.theMonthData.append(i)
            }
        
            self.tableView.reloadData()
        })
    }
    
    func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    //Header of each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.theFallData?.results[section].month
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.theFallData?.results.count ?? 0
    }

    //Each section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        cell.date.text = String(self.theMonthData[indexPath.row].description[indexPath.row].date)
        self.assignments = self.theMonthData[indexPath.row].description[indexPath.row].assignments
        cell.detailReading.text = "\(self.assignments[0]), \(self.assignments[1])"
        
        
//        date.text = String(self.theMonthData[indexPath.row].description[indexPath.row].date)
//        cell.textLabel?.text = String(self.theMonthData[indexPath.row].description[indexPath.row].date)
//        self.assignments = self.theMonthData[indexPath.row].description[indexPath.row].assignments
//        cell.detailTextLabel?.text = self.assignments[0] + self.assignments[1]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dateCellExpanded {
            dateCellExpanded = false
        } else {
            dateCellExpanded = true
        }
        expandedIndexpath = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(expandedIndexpath == indexPath){
            if dateCellExpanded {
                return 500
            } else {
                return 40
            }
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theMonthData.count
    }
    
   

}

