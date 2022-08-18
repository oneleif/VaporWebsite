//
//  AuthenticationService.swift
//  
//
//  Created by Rob Maltese on 8/18/22.
//

import Vapor

struct AuthenticationService {
    let request: Request
    func requireAuthorization() async throws -> User {
       let user = try request.auth.require(User.self)
        // Check for permissions prior to returning the user on line 15.
        return user
    }
}


extension Request {
    var authService: AuthenticationService {
        .init(request: self)
    }
}
