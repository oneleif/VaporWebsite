//
//  UserAuthenticator.swift
//  
//
//  Created by Rob Maltese on 8/17/22.
//

import Vapor
import Fluent

extension User: ModelAuthenticatable {
    // Unable to change the static let protocol key over to match naming convention due to how Vapor has setup the protocol.
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
