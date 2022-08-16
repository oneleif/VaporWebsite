//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

final class User: Model, Content {
    var id: UUID?
    // Auth Information
    var email: String
    var password: String
    
    // Social Information
    var social: SocialInformation?
    
    init() { } 
    init(id: UUID? = UUID(), email: String, password: String, social: SocialInformation?) {
        self.id = id
        self.email = email
        self.password = password
        self.social = social
    }
}
