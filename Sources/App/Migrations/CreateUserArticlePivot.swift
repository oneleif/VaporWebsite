//
//  CreateUserArticlePivot.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

struct CreateUserArticlePivot: AsyncMigration {
    func prepare(on database: Database) async throws {
         try await database.schema(UserArticlePivot.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, .id, onDelete: .cascade))
            .field("article_id", .uuid, .required, .references(Article.schema, .id, onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
         try await database.schema(UserArticlePivot.schema)
            .delete()
    }
}
