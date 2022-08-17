//
//  CreateUser.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor


struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("firstName", .string)
            .field("lastName", .string)
            .field("discordUsername", .string)
            .field("githubUsername", .string)
            .field("tags", .array(of: .string))
            .field("links", .array(of: .string))
            .field("profileImage", .string)
            .field("biography", .string)
            .field("location", .string)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema)
    }
}
