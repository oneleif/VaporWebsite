//
//  CreateUser.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent

extension User {
    struct Migration: AsyncMigration {
        var name: String { "CreateUser" }
        
        /// Function in which creates and controls the versioning of the table within the database using `AsyncMigration`.
        func prepare(on database: Database) async throws {
            try await database.schema(User.schema)
                .id()
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .field("firstName", .string)
                .field("lastName", .string)
                .field("discordUsername", .string)
                .field("githubUsername", .string)
                .field("tags", .array(of: .string))
                .field("links", .array(of: .string))
                .field("profileImage", .string)
                .field("biography", .string)
                .field("location", .string)
                .unique(on: "email")
                .create()
        }
        /// Function in which deletes the table from within the database.
        func revert(on database: Database) async throws {
            try await database.schema(User.schema)
                .delete()
        }
    }
}
