//
//  CreateArticle.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Vapor
import Fluent

struct CreateArticle: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Article.schema)
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("author_id", .uuid, .required, .references(User.schema, "id"))
            .field("tags", .array(of: .string))
            .field("url", .string, .required)
            .field("content", .string, .required)
            .field("postDate", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Article.schema)
            .delete()
    }
}
