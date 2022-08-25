//
//  AuthenticationController.swift
//  
//
//  Created by Rob Maltese on 8/17/22.
//

import Vapor
import Fluent

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post(use: signUserUp)
            auth.delete(use: logout)
        }
        routes.post("login", use: loginUser)
    }
    
    /// Function passes in the users email and password which if it meets the `User.Create: Validatable` critera, returns the user.
    func signUserUp(req: Request) async throws -> User {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match.")
        }
        
        let user = try User(
            email: create.email,
            passwordHash: Bcrypt.hash(create.password),
            firstName: nil,
            lastName: nil,
            discordUsername: nil,
            githubUsername: nil,
            tags: [],
            links: [],
            profileImage: nil,
            biography: nil,
            location: nil
        )
        
        try await user.save(on: req.db)
        return user
    }
    
    /// Function destroys the session token then logs the user out.
    func logout(req: Request) async throws -> HTTPStatus {
        req.session.destroy()
        req.auth.logout(User.self)
        return .ok
    }
    
    /// Function logs the user in after verifying the credentials.
    /// - note: Returns the `UserDTO` in order to not pass back the `passwordHash` as it is uneeded.
    func loginUser(req: Request) async throws -> UserDTO {
        let userLogin = try req.content.decode(User.Login.self)
        /// If this passes, it will allow you to use the user. Otherwise, it will simply throw an `Abort(.notFound)`.
        guard let user = try await User.query(on: req.db).filter(\.$email, .equal, userLogin.email).first() else {
            throw Abort(.notFound)
        }
        if try user.verify(password: userLogin.password) {
            req.auth.login(user)
        } else {
            throw Abort(.forbidden, reason: "Password incorrect.")
        }
        return try await user.dto(on: req.db)
    }
}
