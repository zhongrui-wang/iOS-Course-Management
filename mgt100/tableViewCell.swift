//
//  tableViewCell.swift
//  mgt100
//
//  Created by RUI WANG on 11/16/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit
import MapKit

class tableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var readings: UILabel!
    
    @IBOutlet weak var detailReading: UILabel!
    
    @IBOutlet weak var assignments: UILabel!
    
    @IBOutlet weak var detailAssignment: UILabel!
    
    @IBOutlet weak var tahours: UILabel!
    
    @IBOutlet weak var detailTA: UILabel!
    
    @IBOutlet weak var location: MKMapView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
