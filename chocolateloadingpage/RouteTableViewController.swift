//
//  RouteTableViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 12/1/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class RouteTableViewController: UITableViewController {
    
    var route:MKRoute?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Route Steps";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (self.route!.steps.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let step = route?.steps[indexPath.row]

        // Configure the cell...
      //   = [NSString stringWithFormat:"%02ld) %0.1fkm", indexPath.row, step.distance / 1000.0];
        cell.textLabel?.text = String .localizedStringWithFormat("%02ld) %0.1fkm", indexPath.row, step!.distance / 1000.0 as CVarArg);
        cell.detailTextLabel?.text = step?.notice;

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // let cell = sender as! CustomCell
        
        if segue.identifier == "routestep" {
            if let rowStep = self.tableView.indexPathForSelectedRow {
                let detailController = segue.destination as! RouteStepViewController
                detailController.routestep = (self.route?.steps[rowStep.row])!
                detailController.stepIndex = rowStep.row
            }
        }
    }
    

}
