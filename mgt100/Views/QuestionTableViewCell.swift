//
//  QuestionTableViewCell.swift
//  mgt100
//
//  Created by Matheus Bustamante on 11/30/19.
//  Copyright © 2019 Innovation that excites. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.borderWidth = 1
        messageBubble.layer.borderColor = UIColor.black.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
}
