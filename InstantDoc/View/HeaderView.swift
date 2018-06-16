//
//  HeaderView.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 15/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qualificationsLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
    }

}
