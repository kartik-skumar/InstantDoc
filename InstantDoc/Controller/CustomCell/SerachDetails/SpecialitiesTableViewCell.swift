//
//  SpecialitiesTableViewCell.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 13/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit

class SpecialitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var specOneLabel: UILabel!
    @IBOutlet weak var specTwoLabel: UILabel!
    @IBOutlet weak var specThreeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func allServicesClicked(_ sender: Any) {
    }
    
}
