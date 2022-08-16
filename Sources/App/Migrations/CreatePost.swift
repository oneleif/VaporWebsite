//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Vapor
import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema("posts")
            .id()
            .field
    }
}
