//
//  UserController.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: createUser)
    }
    
    /// Query all users within the table.
    func index(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    /// Create user within the table.
    func createUser(req: Request) async throws -> [User] {
        let user = try req.content.decode(User.self)
        try user.save(on: req.db)
        return user
    }
    
    // MARK: - Add PUT here... mainly unsure if we need to explicitly state the change? (ie. identifiedUser.discordUsername = user.discordName)
    
    /// Delete user within table.
    func deleteUser(req: Request) async throws -> HTTPStatus {
        let user = try req.content.decode(User.self)
        guard let identifiedUser = try User.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await identifiedUser.delete(on: req.db)
        return .ok
    }
    
}
