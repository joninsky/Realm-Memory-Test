//
//  ViewController.swift
//  Memory
//
//  Created by Jon Vogel on 11/23/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var myTableView: UITableView!
    
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedRowHeight = 72
        
        
        //Seed data to make some objects
        guard let jsonFile = Bundle.main.path(forResource: "generated", ofType: "json") else{
            return
        }
        
        let jsonURL = URL(fileURLWithPath: jsonFile)
        
        var JSON: [String]!
        
        
        do{
            
            let jsonData = try Data(contentsOf: jsonURL, options: .mappedIfSafe)
            JSON = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String]
            
        }catch{
            return
        }
        
        
        //Class that is managing my Realm Stuff. See this class for my leaky tests!
        let userExperiments = ExperimentsOnFriends()
        
        
        //Flow similar to what I would use to manage a 'loggedIn' User in a production scenario.
        do{
            print("Getting Logged in User!")
            let user = try userExperiments.loggedInUser()
            
            self.user = user
            
        }catch GetUserError.noUser {
            print("No User Logged in. Time to make one!")
            
            do{
                let newUser = try userExperiments.logInUser(withFriends: JSON, "Test User")
                
                self.user = newUser
                
            }catch LoginUserError.realmError(let error){
                print("Realm Error creating User: \(error)")
                do{
                    try userExperiments.resetUsers()
                }catch{
                    print("Failed to reset Users. Bad app state!")
                }
            }catch{
                print("Unhandled error")
                do{
                    try userExperiments.resetUsers()
                }catch{
                    print("Failed to reset Users. Bad app state!")
                }
            }
            
        }catch GetUserError.toManyUsers{
            print("Multiple User Records. We don't want this so delete them. Should recover next launch.")
            do{
                try userExperiments.resetUsers()
            }catch{
                print("Failed to reset Users. Bad app state!")
            }
            
        }catch GetUserError.realmError(let error){
            print("Got Realm Error: \(error)")
            do{
                try userExperiments.resetUsers()
            }catch{
                print("Failed to reset Users. Bad app state!")
            }
        }catch{
            print("Unhandled error")
            do{
                try userExperiments.resetUsers()
            }catch{
                print("Failed to reset Users. Bad app state!")
            }
        }
        
        
    }


    
    //MARK: TableView Stuff
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let u = self.user else{
            return 0
        }
        
        
        return u.friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "FRIENDCELL") as! FriendCell
        guard let u = self.user else{
            return Cell
        }
        
        
         let friend = u.friends[indexPath.row]
        
        
        Cell.friendName.text = friend.name
        
        return Cell
    }
    
    
    deinit {
        print("De-initalized ViewController that contains friends list.")
    }

}

