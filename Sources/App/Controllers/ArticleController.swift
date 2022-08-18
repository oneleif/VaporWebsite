//
//  ArticleController.swift
//  
//
//  Created by Leif on 8/17/22.
//

import Fluent
import Vapor
import Fork

struct ArticleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let articles = routes
            .grouped(User.guardMiddleware())
            .grouped("articles")
        
        articles.get(use: index)
        articles.post(use: create)
        
        articles.group(":id") { article in
            article.get(use: find)
            article.put(use: update)
            article.delete(use: delete)
        }
    }
    
    // MARK: - Public Endpoints
    
    /// Query all Articles within the table.
    func index(req: Request) async throws -> [Article] {
        return try await Article.query(on: req.db).all()
    }
    
    /// Create an Article within the table.
    func create(req: Request) async throws -> Article {
        let articleCreate = try req.content.decode(ArticleCreate.self)
        
        let author = try await req.authService.requireAuthorization()
        
        let coauthorUsers = try await User.query(on: req.db).all()
            .filter { user in articleCreate.coauthors.contains(where: { user.id == $0 })}
        
        let article = Article(
            title: articleCreate.title,
            description: articleCreate.description,
            author: try author.requireID(),
            tags: articleCreate.tags,
            url: articleCreate.url,
            content: articleCreate.content,
            postDate: articleCreate.postDate
        )
        
        try await article.save(on: req.db)
        
        try await Fork(
            leftOutput: { try await author.$articles.attach(article, on: req.db) },
            rightOutput: { try await article.$coauthors.attach(coauthorUsers, on: req.db) }
        )
        .merged()
        
        return article
    }
    
    /// Find the Article for the provided Article ID
    func find(req: Request) async throws -> Article {
        try await findArticle(id: req.parameters.get("id"), on: req.db)
    }
    
    /// Update the Article within the table after checking that the author requesting the update, matches the author of the article.
    func update(req: Request) async throws -> Article {
        let author = try await req.authService.requireAuthorization()
        let articleID: UUID? = req.parameters.get("id")
        
        guard try await author.$articles.get(on: req.db).contains(where: { $0.id == articleID }) else {
            throw Abort(.forbidden, reason: "Requesting author is not a contributor.")
        }
        
        let identifiedArticle = try await findArticle(id: articleID, on: req.db)
        let updatedArticleDTO = try req.content.decode(ArticleUpdate.self)
        
        identifiedArticle.update(with: updatedArticleDTO)
        try await identifiedArticle.update(on: req.db)
        return identifiedArticle
    }
    
    /// Delete the Article within the table after checking that the author requesting the delete, matches the author of the article.
    func delete(req: Request) async throws -> HTTPStatus {
        let author = try await req.authService.requireAuthorization()
        let articleID: UUID? = req.parameters.get("id")
        let identifiedArticle = try await findArticle(id: articleID, on: req.db)
        guard author.id == identifiedArticle.author.id else {
            throw Abort(.badRequest, reason: "Requesting author doesn't match article author.")
        }
        try await identifiedArticle.delete(on: req.db)
        return .ok
    }
    
    // MARK: - Private Helpers
    
    private func findArticle(id: UUID?, on database: Database) async throws -> Article {
        guard
            let identifiedArticle = try await Article.find(id, on: database)
        else { throw Abort(.notFound) }
        
        return identifiedArticle
    }
    
    
}
