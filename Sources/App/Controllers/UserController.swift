//
//  UserController.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

/// User route controller.
struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: createUser)
        
        users.group(":id") { user in
            user.get(use: find)
            user.put(use: update)
            user.delete(use: deleteUser)
        }
    }
    
    // MARK: - Public Endpoints
    
    /// Query all users within the table.
    func index(req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map(\.dto)
    }
    
    /// Create user within the table.
    func createUser(req: Request) async throws -> UserDTO {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user.dto
    }
    
    /// Find the User for the provided User ID
    func find(req: Request) async throws -> UserDTO {
        try await findUser(req: req).dto
    }
    
    /// Update the user withing the table
    func update(req: Request) async throws -> UserDTO {
        let identifiedUser = try await findUser(req: req)
        let updatedUserDTO = try req.content.decode(UserSocialUpdate.self)
        
        identifiedUser.update(with: updatedUserDTO)
        
        try await identifiedUser.update(on: req.db)
        
        return identifiedUser.dto
    }
    
    /// Delete user within table.
    func deleteUser(req: Request) async throws -> HTTPStatus {
        guard let identifiedUser = try await User.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await identifiedUser.delete(on: req.db)
        return .ok
    }
    
    // MARK: - Private Helpers
    /// Private function to find the User ID from within the table.
    private func findUser(req: Request) async throws -> User {
        guard
            let identifiedUser = try await User.find(req.parameters.get("id"), on: req.db)
        else { throw Abort(.notFound) }
        
        return identifiedUser
    }
}
