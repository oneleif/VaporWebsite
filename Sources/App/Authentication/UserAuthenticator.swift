//
//  UserAuthenticator.swift
//  
//
//  Created by Rob Maltese on 8/17/22.
//

import Vapor
import Fluent

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
