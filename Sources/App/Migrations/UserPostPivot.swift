//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

struct UserPostPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
         try await database.schema(UserPost.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, \.id, onDelete: .cascade))
            .field("post_id", .uuid, .required, .references(Post.schema, \.id, onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
         try await database.schema(UserPost.schema)
    }
}

