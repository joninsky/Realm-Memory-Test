//
//  ExperimentsOnFriends.swift
//  Memory
//
//  Created by Jon Vogel on 11/28/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation
import RealmSwift

enum LoginUserError: Error {
    case realmError(e: Error)
}


enum GetUserError: Error {
    case noUser
    case toManyUsers
    case realmError(e: Error)
}

class ExperimentsOnFriends {
    
    /*
     INTRO
     
     
    These are all my leaky experiments. I noticed something was up when I started testing version 2.1.0 in a production app. The app leaked memory and when I deleted objects, the size of the Realm grew to almost a gigabyte and then returned invalid, this manifests itself in my app as logging the user out. Anyway, I think the ballooning Realm Size is a different issue because it looks like objects still leak all the way back to 2.0.2. These experiments are to point out my observations of realm leaks.
     
     
     Also, and as always, if you see something missing or wrong with my code or submission you can twist the knife, I’m thick skinned.
     
     
     Now, behold! My Experiments! Comment and uncomment as appropriate.
 
     */
    
    
    /*
     
     EXPERIMENT 1! - TESTED WITH LEAKS INSTRUMENT.
     
    Tested Realm v 2.0.2 and v 2.1.0
     
     This is (very close) to how I would use realm to manage a logged in user in production. I would switch my UI around depending if I could get the user or not.
     
     
     In this case all objects are added and then subsequently managed by Realm. The only thing that leaks is the ‘friends’ property on the User class. This is of Realm type List<Friend>.
     
     
     So, why are List<> objects leaking? Am I misusing them or is this a bug?
     
    
    */
    
//    func logInUser(withFriends friends: [String], _ userName: String) throws -> User {
//        
//        let user = User()
//
//        user.name = userName
//        
//        for name in friends {
//            let f = Friend()
//            f.name = name
//            user.friends.append(f)
//        }
//        
//        do {
//            
//            let realm = try Realm()
//            
//            try realm.write {
//                realm.add(user)
//            }
//        }catch{
//            throw LoginUserError.realmError(e: error)
//        }
//        
//        return user
//        
//    }
//    
//    
//    func loggedInUser() throws -> User?  {
//        
//        
//        var users: Results<User>
//        
//        do{
//            let realm = try Realm()
//            
//            users = realm.objects(User.self)
//            
//        }catch{
//            throw GetUserError.realmError(e: error)
//        }
//        
//        if users.count > 1{
//            throw GetUserError.toManyUsers
//        }else if users.count == 0{
//            throw GetUserError.noUser
//        }
//        
//        return users.first
//        
//    }
    
    /*
    EXPERIMENT 2! - TESTED WITH LEAKS INSTRUMENT.
    Tested Realm v 2.0.2 and v 2.1.0
     
     In this experiment I just modified the ‘loggedInUser()’ function to generate a User object with friends and then NOT add it to realm. Just keep the object in memory.
     
     
     Here major leaks happen! The culprit seems to be both the List object from the previous experiment and now the ‘LinkingObjects’ property of the ‘Friend’ class.
     
     
     This is problematic because there are a lot of times that I am creating objects that have the potential to be saved to realm but are not because of various reasons.
     
     
     So, am I misusing the Realm or is this something that can be fixed?
     
    */
    
    func logInUser(withFriends friends: [String], _ userName: String) throws -> User {
        
        let user = User()
        
        user.name = userName
        
        for name in friends {
            let f = Friend()
            f.name = name
            user.friends.append(f)
        }
        
        do {
            
            let realm = try Realm()
            
            try realm.write {
                realm.add(user)
            }
        }catch{
            throw LoginUserError.realmError(e: error)
        }
        
        return user
        
    }
    
    
    func loggedInUser() throws -> User?  {
        
        guard let jsonFile = Bundle.main.path(forResource: "generated", ofType: "json") else{
            return nil
        }
        
        let jsonURL = URL(fileURLWithPath: jsonFile)
        
        var JSON: [String]!
        
        
        do{
            
            let jsonData = try Data(contentsOf: jsonURL, options: .mappedIfSafe)
            JSON = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String]
            
        }catch{
            return nil
        }
        
        
        let user = User()
        
        user.name = "Test User"
        
        for name in JSON {
            let f = Friend()
            f.name = name
            user.friends.append(f)
        }
        
        return user

        
    }
    
    
    //This is just to clean up Realm if needed between launches or because of some error.
    func resetUsers() throws {
        do{
           let realm = try Realm()
            
            try realm.write {
                realm.deleteAll()
            }
        }catch{
            throw error
        }
    }

    
    
    
}
