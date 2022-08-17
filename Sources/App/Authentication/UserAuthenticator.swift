//
//  UserAuthenticator.swift
//  
//
//  Created by Rob Maltese on 8/17/22.
//

import Vapor

extension User: Authenticatable { }

struct UserAuthenticator: AsyncBasicAuthenticator {
    typealias User = App.User
    let user: User
    func authenticate(basic: BasicAuthorization, for request: Request) async throws {
        if basic.username == user.email && basic.password == user.password {
            request.auth.login(user)
        }
    }
}
