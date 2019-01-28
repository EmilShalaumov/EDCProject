//
//  User.swift
//  EDCClient (mac)
//
//  Created by Эмиль Шалаумов on 26/01/2019.
//  Copyright © 2019 Emil Shalaumov. All rights reserved.
//

import Foundation

class AppUser {
    static let instance = AppUser()
    
    var _username: String!
    
    var username: String {
        get {
            return _username
        }
        set(user) {
            _username = user
        }
    }
    
    init() {
        self._username = "%username%"
    }
    
    init(username: String) {
        self._username = username
    }
}
