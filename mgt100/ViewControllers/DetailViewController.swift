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
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        UIView.animate(withDuration: 0.4) {
            statusBar?.backgroundColor = UIColor(red: 57/255.0, green: 90/255.0, blue: 255/255.0, alpha: 1)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        UIView.animate(withDuration: 0.3) {
            statusBar?.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        dateLabel.text = date
        detailedAssignments.text = assignmnets
        setUpTableView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupMap()
            DispatchQueue.main.async {
                self.getMapData()
            }
        }
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
            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 17)
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = arrayOfReadings[indexPath.row].name

            cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 17)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.taTableView){
            
        } else {
            if(arrayOfReadings[indexPath.row].link == ""){
                let refreshAlert = UIAlertController(title: "Reading not available", message: "Sorry we dont have this reading in our database", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(refreshAlert, animated: true, completion: nil)
            } else {
                // ********* Reading Pdf View *********
                let webView = WKWebView(frame: self.view.frame)
                let urlRequest = URLRequest(url: URL(string: arrayOfReadings[indexPath.row].link)!)
                webView.load(urlRequest as URLRequest)
                let pdfVC = UIViewController()
                pdfVC.view.addSubview(webView)
                pdfVC.title = arrayOfReadings[indexPath.row].name
                let button = UIButton(frame: CGRect(x: 0, y: 50, width: pdfVC.view.frame.width, height: 55))
                button.backgroundColor = #colorLiteral(red: 0.2235294118, green: 0.3529411765, blue: 1, alpha: 1)
                button.setTitle("Close", for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                button.addTarget(self, action: #selector(closePdfController), for: .touchUpInside)
                pdfVC.view.addSubview(button)
                self.present(pdfVC, animated: true, completion: nil)
            }
           
        }
    }
    // ********* Close Pdf View Controller Button *********
    @objc func closePdfController(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
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
