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
import EventKit

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
        let readings: [Readings]
        let tas: [String]
        let date: Int!
    }
    
    struct Readings: Codable {
        let name: String
        let link: String
    }
    
    
    var theFallData: APIResults?
    var theMonthData: [Months] = []
    var assignments: [String] = []
    var tas: [String] = []
    var readings: [String] = []
    var dateCellExpanded: Bool = false
    var expandedIndexpath = IndexPath()
    
    var indexPathSelected: IndexPath?
    
    var getMonthName: String!
    
    //Store value from each row
    var arrayOfTas: [String] = []
    var dateComponents = DateComponents()
    //Main table view
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addingToCalendar(_ sender: UIButton) {
        
        func getFunctionName(monthName: String) -> Int{
            switch monthName {
            case "September":
                return 9
            case "October":
                return 10
            case "November":
                return 11
            case "December":
                return 12
            default:
                return 0
            }
        }
        if self.theMonthData[indexPathSelected!.section].description[indexPathSelected!.row].tas[0] != "None"{
            dateComponents.year = 2019
            let getMonth = String(self.theMonthData[indexPathSelected!.section].month)
            let getDate = Int(self.theMonthData[indexPathSelected!.section].description[indexPathSelected!.row].date)
            
            dateComponents.month = getFunctionName(monthName: getMonth)
            dateComponents.day = getDate
            dateComponents.timeZone = TimeZone(abbreviation: "EST")
            dateComponents.hour = 10
            dateComponents.minute = 00
        
            let Date = Calendar.current.date(from: dateComponents)
            
            
            addEventToCalendar(title: "Mgt 100", description: "TA Office Hours", startDate: Date!, endDate: Date!.addingTimeInterval(2*60*60))
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.grabFirebaseData()
        self.setUpTableView()
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    let refreshAlert = UIAlertController(title: "Successfull!", message: "Event on '\(self.theMonthData[(self.indexPathSelected!.section)].month), \(String( self.theMonthData[(self.indexPathSelected!.section)].description[self.indexPathSelected!.row].date))' added to calendar", preferredStyle: UIAlertController.Style.alert)
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(refreshAlert, animated: true, completion: nil)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                
            } else {
                completion?(false, error as NSError?)
            }
        })
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
    
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
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
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
 
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "Poppins-Bold", size: 25)

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(75)
    }

 
    //Each section
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! tableViewCell
        
        
        
        // Shadow
        cell.detailFrameCell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.detailFrameCell.layer.shadowRadius = 2
        cell.detailFrameCell.layer.shadowOpacity = 0.3
        cell.detailFrameCell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.detailFrameCell.layer.masksToBounds = false

        
        cell.date.text = String(self.theMonthData[indexPath.section].description[indexPath.row].date)
        
        let arrayOfAssignment = self.theMonthData[indexPath.section].description[indexPath.row].assignments.joined(separator: ", ")
        
        var dumpReading = ""
        
        for (i, b) in self.theMonthData[indexPath.section].description[indexPath.row].readings.enumerated() {
            if(i == self.theMonthData[indexPath.section].description[indexPath.row].readings.count-1) {
                dumpReading += "\(b.name)"
                
            }else{
                dumpReading += "\(b.name), "
            }
            
            
        }
        
        let arrayOfTaS = self.theMonthData[indexPath.section].description[indexPath.row].tas.joined(separator: ", ")
        
        cell.detailAssignment.text = arrayOfAssignment
        cell.detailReading.text = dumpReading
        cell.detailTA.text = arrayOfTaS
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dateCellExpanded {
            dateCellExpanded = false
            if let cell = tableView.cellForRow(at: indexPath) as? tableViewCell {
                UIView.animate(withDuration: 0.3) {
                    cell.detailFrameCell.frame.size.height = CGFloat(82)
                }
            }
        } else {
            dateCellExpanded = true
            if let cell = tableView.cellForRow(at: indexPath) as? tableViewCell {
                cell.detailFrameCell.frame.size.height = CGFloat(530)
            }
        }
        expandedIndexpath = indexPath
        tableView.beginUpdates()
        tableView.endUpdates()
        indexPathSelected = indexPath
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(expandedIndexpath == indexPath){
            if dateCellExpanded {
                if let cell = tableView.cellForRow(at: indexPath) as? tableViewCell {
                    cell.detailFrameCell.frame.size.height = CGFloat(530)
                }
                return 550
            } else {
                if let cell = tableView.cellForRow(at: indexPath) as? tableViewCell {
                    UIView.animate(withDuration: 0.3) {
                        cell.detailFrameCell.frame.size.height = CGFloat(82)
                    }
                }
                return 100
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) as? tableViewCell {
            UIView.animate(withDuration: 0.3) {
                cell.detailFrameCell.frame.size.height = CGFloat(82)
            }
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.theFallData?.results[section].description.count)!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DetailViewController
        {
            let detailedViewController = segue.destination as? DetailViewController
            
            let arrayOfAssignment = self.theMonthData[indexPathSelected!.section].description[indexPathSelected!.row].assignments.joined(separator: ", ")
            
            detailedViewController?.arrayOfReadings = self.theMonthData[indexPathSelected!.section].description[indexPathSelected!.row].readings
            
            detailedViewController?.assignmnets = arrayOfAssignment
            
            detailedViewController?.date = "\(self.theMonthData[(indexPathSelected!.section)].month), \(String( self.theMonthData[(indexPathSelected!.section)].description[indexPathSelected!.row].date))"
            
            detailedViewController?.teachingAssistans = self.theMonthData[indexPathSelected!.section].description[indexPathSelected!.row].tas
            
        }
    }
    
    
    
    
    
    
    
    

}

