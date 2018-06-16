//
//  LocationTableViewCell.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 13/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
