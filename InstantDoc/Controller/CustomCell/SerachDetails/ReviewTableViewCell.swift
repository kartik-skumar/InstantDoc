//
//  ReviewTableViewCell.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 13/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var reviewOneLabel: UILabel!
    @IBOutlet weak var reviewTwoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func allReviewsClicked(_ sender: Any) {
    }
    
    @IBAction func writeReviewLabel(_ sender: Any) {
    }
}
