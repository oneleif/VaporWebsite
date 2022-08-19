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
    
    /// Sign User Up.
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
    
    func logout(req: Request) async throws -> HTTPStatus {
        req.session.destroy()
        req.auth.logout(User.self)
        return .ok
    }
    
    /// Log User In.
    func loginUser(req: Request) async throws -> UserDTO {
        let userLogin = try req.content.decode(User.Login.self)
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
