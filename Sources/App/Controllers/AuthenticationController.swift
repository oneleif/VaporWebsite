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
        let passwordProtected = routes.grouped("login")
        passwordProtected.post(use: signUserUp)
    }
    
    /// Sign user up.
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
    
}
