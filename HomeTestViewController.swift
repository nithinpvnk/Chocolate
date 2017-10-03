////
////  HomeTestViewController.swift
////  chocolateloadingpage
////
////  Created by Nithin Kumar on 11/23/16.
////  Copyright © 2016 Nithin Kumar. All rights reserved.
////
//
//import UIKit
//import p2_OAuth2
//import YelpAPI
//
//class HomeTestViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
//
//    var businesses: [Business]!
//    
//    @IBOutlet weak var activityIndicator:UIActivityIndicatorView;
//    
//    @IBOutlet weak var resultTableView:UITableView;
//    
//    @IBOutlet  weak var tableViewDisplayDataArray:NSMutableArray;
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
//            
//            self.businesses = businesses
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
//            
//        })
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
