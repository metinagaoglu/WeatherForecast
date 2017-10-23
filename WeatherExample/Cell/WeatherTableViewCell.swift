//
//  WeatherTableViewCell.swift
//  WeatherExample
//
//  Created by Metin Ağaoğlu on 19.10.2017.
//  Copyright © 2017 Metin Ağaoğlu. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    

    @IBOutlet weak var timeText: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
