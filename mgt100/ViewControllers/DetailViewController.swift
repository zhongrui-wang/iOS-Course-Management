//
//  DetailViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/18/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import MapKit
import WebKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taHours: UILabel!
    @IBOutlet weak var taTableView: UITableView!
    @IBOutlet weak var readingTableView: UITableView!
    
    
    @IBOutlet weak var detailedAssignments: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var date: String?
    var readings: String?
    var assignmnets: String?
    var teachingAssistans: [String] = []
    var region: MKCoordinateRegion?
    var location: CLLocationCoordinate2D?
    
    var arrayOfReadings: [ViewController.Readings] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        //statusBar?.backgroundColor = UIColor.white
//        statusBar?.backgroundColor = UIColor(red: 57/255.0, green: 90/255.0, blue: 255/255.0, alpha: 1)
//        
        dateLabel.text = date
        detailedAssignments.text = assignmnets
        setUpTableView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupMap()
            DispatchQueue.main.async {
                self.getMapData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView(){
        taTableView.dataSource = self
        taTableView.delegate = self
        readingTableView.dataSource = self
        readingTableView.delegate = self
        taTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        readingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.taTableView){
            return teachingAssistans.count
        }
        
        return arrayOfReadings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.taTableView){
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel!.text = teachingAssistans[indexPath.row]
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = arrayOfReadings[indexPath.row].name
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.taTableView){
            
        } else {
            if(arrayOfReadings[indexPath.row].link == ""){
                let refreshAlert = UIAlertController(title: "No pdf available", message: "Sorry we dont have this pdf in our database", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                let webView = WKWebView(frame: self.view.frame)
                let urlRequest = URLRequest(url: URL(string: arrayOfReadings[indexPath.row].link)!)
                webView.load(urlRequest as URLRequest)
                
                let pdfVC = UIViewController()
                pdfVC.view.addSubview(webView)
                pdfVC.title = arrayOfReadings[indexPath.row].name
                self.navigationController?.pushViewController(pdfVC, animated: true)
            }
           
        }
    }
    
    func setupMap(){
        location = CLLocationCoordinate2D(latitude: 38.6471275, longitude: -90.3026611)
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        region = MKCoordinateRegion(center: location!, span: span)
    }
    
    func getMapData(){
        mapView.setRegion(region!, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location!
        annotation.title = "Washington University in St.Louis"
        annotation.subtitle = "Room 204B"
        mapView.addAnnotation(annotation)
    }
    
}
