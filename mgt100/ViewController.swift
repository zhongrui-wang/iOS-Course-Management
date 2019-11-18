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
    
    var indexPathSelected: IndexPath?
    
    
    //Store value from each row
    var arrayOfTas: [String] = []
    
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
            print("fetched!")
            self.tableView.reloadData()
        })
    }
    
    func setUpTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }

    //Header of each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.theFallData?.results[section].month
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.theFallData?.results.count ?? 0
    }
    
    //Table view header styling
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 0.18, green: 0.49, blue: 0.82, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
    }


    //Each section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell

        cell.date.text = String(self.theMonthData[indexPath.section].description[indexPath.row].date)
        
        let arrayOfAssignment = self.theMonthData[indexPath.section].description[indexPath.row].assignments.joined(separator: ", ")
        let arrayOfReadings = self.theMonthData[indexPath.section].description[indexPath.row].readings.joined(separator: ", ")
        let arrayOfTaS = self.theMonthData[indexPath.section].description[indexPath.row].tas.joined(separator: ", ")
        
        cell.detailAssignment.text = arrayOfAssignment
        cell.detailReading.text = arrayOfReadings
        cell.detailTA.text = arrayOfTaS
        cell.selectionStyle = .none
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
        indexPathSelected = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(expandedIndexpath == indexPath){
            if dateCellExpanded {
                return 400
            } else {
                return 65.33
            }
        }
        return 65.33
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.theFallData?.results[section].description.count)!
    }
    
    
    @IBAction func loadDetail(_ sender: UIButton) {
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedViewController = mainStoryBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        print(indexPathSelected!)
        detailedViewController.date = String(self.theMonthData[(indexPathSelected!.section)].description[indexPathSelected!.row].date)
    
        
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }

}

