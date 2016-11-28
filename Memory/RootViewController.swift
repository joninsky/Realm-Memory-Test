//
//  RootViewController.swift
//  Memory
//
//  Created by Jon Vogel on 11/28/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit



class RootViewController: UIViewController {
    //MARK: Properties
    
    @IBOutlet var goToButton: UIButton!
    
    
    @IBOutlet var noRealmButton: UIButton!
    
    
    //MARK: Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    //MARK: Actions
    
    @IBAction func goToFriendsPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "ShowFriends", sender: self)
        
        
        
    }
    
    @IBAction func noRealmPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "NORealmVC", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "ShowFriends":
            guard let _ = segue.destination as? ViewController else{
                return
            }
            
        case "NORealmVC":
            print("To no Realm VC")
            
        default:
            return
        }
        
        
    }
    
    
}
