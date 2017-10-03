////
////  SavedPreferences.swift
////  chocolateloadingpage
////
////  Created by Nithin Kumar on 11/27/16.
////  Copyright © 2016 Nithin Kumar. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Firebase
//
//class LabelToBeDisplayed: NSObject
//{
//    var locationName: String
//     var databaseReferenceForProfile:FIRDatabaseReference!
//    
//    init(locationName: String) {
//        self.locationName = locationName
//        super.init()
//    }
//    convenience init(random: Bool)
//    {
//        
//        let userID:String = (FIRAuth.auth()?.currentUser?.uid)!
//        databaseReferenceForProfile.child("Users").child(userID).child("Address").observeSingleEvent(of: .value, with: {(FIRDataSnapshot)
//            in
//            if let dic  = FIRDataSnapshot.value as? [String: AnyObject]
//            {
//                self.locationName = (dic["LocationName"] as? String)!
//            }
//            }, withCancel: nil)
//        
//        
//            self.init(locationName: locationName)
//    }
//    
//    //encodeWithCoder() encodes an intance of "Item" inside the NSCoder instance that is passed in the argument
//    func encode(with aCoder: NSCoder) {
//        print("Encoding: \(locationName)")
//        aCoder.encode(locationName, forKey: "locationName")
//    }
//    
//    //init() returns an object initialized from data in the NSCoder instance that is passed in the argument
//    required init(coder aDecoder: NSCoder) {
//        locationName = aDecoder.decodeObject(forKey: "locationName") as! String
//        super.init()
//    }
//}
