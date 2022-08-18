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
        let auth = routes.grouped("auth")
        auth.post(use: signUserUp)
        
        let passwordProtected = routes.grouped("login")
        passwordProtected.post(use: loginUser)
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
            firstName: "",
            lastName: "",
            discordUsername: "",
            githubUsername: "",
            tags: [],
            links: [],
            profileImage: "",
            biography: "",
            location: ""
        )
        
        try await user.save(on: req.db)
        return user
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
