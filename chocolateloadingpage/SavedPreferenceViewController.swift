//
//  SavedPreferenceViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 11/27/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit

class SavedPreferenceViewController: UITableViewController {
   // var labelDisp : LabelToBeDisplayedStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 56
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    //function that commits the editing style of a specified row.
 //   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 //       if editingStyle == .delete {
//            //print("Trying to delete Section: \(indexPath.section) Row: \(indexPath.row)")
//            let item = labelDisp.allLabel[indexPath.row]
//            
//            let title = "Delete it ?"
//            
//            let message = "Are you sure?"
//            
//            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            
//            ac.addAction(cancelAction)
//            
//            let deleteAction = UIAlertAction(title: "Delete",
//                                             style: .destructive,
//                                             handler: {_ in
//                                                //deletes the item from the array
//                                                self.labelDisp.removeItem(item)
//                                                
//                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            })
//            
//            ac.addAction(deleteAction)
//            
//            present(ac, animated: true, completion: nil)
//        }
//    }
//    
  //      }
}
