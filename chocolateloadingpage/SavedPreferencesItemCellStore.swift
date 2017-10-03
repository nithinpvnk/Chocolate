////
////  SavedPreferencesItemCellStore.swift
////  chocolateloadingpage
////
////  Created by Nithin Kumar on 11/28/16.
////  Copyright © 2016 Nithin Kumar. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class LabelToBeDisplayedStore {
//    var allLabel = [LabelToBeDisplayed]()
//    
//    //itemArchiveURL is the URL of the archive where we will save the allItems array
//    let itemArchiveURL: URL = {_ in
//        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent("items.archive")
//    }()
//    
//    //saveChanges() archives the allItems array to the specified file
//    func saveChanges() -> Bool {
//        print("Saving items to: \(itemArchiveURL.path)")
//        
//        //archiveRootObject() creates an instance of NSKeyedArchiver (which is a sub-class of NSCoder)
//        //and calls encodeWithCoder() on the root object (the allItems array)
//        //and subsequently encodeWithCoder() on all of its sub-objects RECURSIVELY
//        //to save all the items inside the same instance of the NSKeyedArchiver
//        return NSKeyedArchiver.archiveRootObject(allLabel, toFile: itemArchiveURL.path)
//    }
//    
//    
//    //creates the allItems array from the data saved in the archive
//    init() {
//        //NSKeyedUnarchiver returns an Anyobject? initialized from data in the archive, which we downcast to [Item] (since the archive actually stores an [Item] object)
//        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [LabelToBeDisplayed] {
//            allLabel += archivedItems
//        }
//    }
//    
//    //function to create an item
//    func createItem() -> LabelToBeDisplayed {
//        let newItem = LabelToBeDisplayed(random: true)
//        
//        allLabel.append(newItem)
//        
//        return newItem
//    }
//    
//    //function to remove specified item from the array
//    func removeItem(_ item: LabelToBeDisplayed) {
//        if let index = allLabel.index(of: item) {
//            allLabel.remove(at: index)
//        }
//    }
//    
//    //function to reorder an item in the array
//    func moveItem(_ fromIndex: Int, toIndex: Int) {
//        if fromIndex == toIndex {
//            return
//        }
//        
//        let movedItem = allLabel[fromIndex]
//        
//        allLabel.remove(at: fromIndex)
//        
//        allLabel.insert(movedItem, at: toIndex)
//    }
//}
