//
//  SearchDetailsViewController.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 13/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit

class SearchDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var displayLabel: String?
    var qualLabel: String?
    var specialityLabel: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib.init(nibName: "HeaderView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderView")
        tableView.tableFooterView = UIView()
        guard (displayLabel != nil) else {
            displayLabel = ""
            return
        }
        self.title = displayLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! HeaderView
        headerView.displayImage.image = UIImage(named: "profile pic")
        headerView.nameLabel.text = displayLabel
        headerView.qualificationsLabel.text = qualLabel
        headerView.specialityLabel.text = specialityLabel
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        switch indexPath.row {
        case 0:
            let ratingCell: RatingTableViewCell = RatingTableViewCell()
            cell = ratingCell
            break
        case 1:
            let consultationCell: ConsulationFeesTableViewCell = ConsulationFeesTableViewCell()
            cell = consultationCell
            break
        case 2:
            let locationCell: LocationTableViewCell = LocationTableViewCell()
            cell = locationCell
            break
        case 3:
            let reviewCell: ReviewTableViewCell = ReviewTableViewCell()
            cell = reviewCell
            break
        case 4:
            let specialitiesCell: SpecialitiesTableViewCell = SpecialitiesTableViewCell()
            cell = specialitiesCell
            break
        case 5:
            let availableCell: AvailableTableViewCell = AvailableTableViewCell()
            cell = availableCell
            break
        default:
            break
        }
        return cell
    }

}
