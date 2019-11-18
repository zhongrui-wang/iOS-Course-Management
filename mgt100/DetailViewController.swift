//
//  DetailViewController.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/18/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taHours: UILabel!
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var detailedReadings: UILabel!
    @IBOutlet weak var detailedAssignments: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var date: String?
    var readings: String?
    var assignmnets: String?
    var teachingAssistans: [String] = []
    var region: MKCoordinateRegion?
    var location: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateLabel.text = date
        detailedReadings.text = readings
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
        theTableView.dataSource = self
        theTableView.delegate = self
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teachingAssistans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = teachingAssistans[indexPath.row]
        return cell
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
