//
//  CustomViewCell.swift
//  WeatherApp
//
//  Created by iMac on 1/25/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var kondisi: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var temperatur: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
