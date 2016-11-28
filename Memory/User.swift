//
//  User.swift
//  Memory
//
//  Created by Jon Vogel on 11/23/16.
//  Copyright © 2016 Jon Vogel. All rights reserved.
//

import Foundation
import RealmSwift




class User: Object {
    
    
    dynamic var name: String?
    
    
    var friends = List<Friend>()
    
    
}
