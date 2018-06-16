//
//  DashboardTableViewController.swift
//  InstantDoc
//
//  Created by Kartik's MacG on 11/05/18.
//  Copyright © 2018 kaTRIX. All rights reserved.
//

import UIKit

class DashboardTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dashboardTitles: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dashboard"
        dashboardTitles = ["Book an appointment", "Chat with a doctor now", "Upload medical records"]
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DashboardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "dashCell") as! DashboardTableViewCell
        cell.titleLabel.text = dashboardTitles?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "searchVC") as UIViewController, animated: true)
            break
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! ChatNavViewController
            self.show(vc, sender: nil)
//            self.present(vc, animated: false, completion: nil)
//            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "chatListVC") as UIViewController, animated: true)
            break
        case 2:
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "recordsListVC") as UIViewController, animated: true)
            break
        default:
            break
        }
    }

}
