//
//  SettingsViewController.swift
//  chocolateloadingpage
//
//  Created by Nithin Kumar on 11/16/16.
//  Copyright © 2016 Nithin Kumar. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var nightModeSwitch: UISwitch!
    
    var nightMode = Bool()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        if(nightMode == true)
        {
            nightModeSwitch.isOn = true
        }
        else
        {
            nightModeSwitch.isOn = false
        }
    }
   
    

    @IBAction func logoutButton(_ sender: UIButton) {
        try! FIRAuth.auth()?.signOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "loginpage")
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func nightModeAction(_ sender: UISwitch) {
        if(nightModeSwitch.isOn == true)
        {
            //var nightModeCheck = UserDefaults.StandardUserDefaults()
            
           // nightModeCheck.setBool(true, forKey: "DarkMode")
        }
    }

}
