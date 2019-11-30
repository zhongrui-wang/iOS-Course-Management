//
//  TATableViewCell.swift
//  mgt100
//
//  Created by Saulet Yskak on 11/30/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit

class TATableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var taMajor: UILabel!
    @IBOutlet weak var taName: UILabel!
    @IBOutlet weak var taImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        taImage.layer.masksToBounds = false
        taImage.layer.cornerRadius = taImage.frame.height/2
        taImage.clipsToBounds = true
        
        taImage.layer.shadowColor = UIColor.darkGray.cgColor
        taImage.layer.shadowRadius = 4
        
        
        // Configure the view for the selected state
    }

}
