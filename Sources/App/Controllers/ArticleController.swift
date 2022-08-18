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
        let articles = routes.grouped("articles")
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
        try await Article.query(on: req.db).all()
    }
    
    /// Create an Article within the table.
    func create(req: Request) async throws -> Article {
        let articleCreate = try req.content.decode(ArticleCreate.self)
        
        guard
            let author = try await User.find(articleCreate.author, on: req.db)
        else { throw Abort(.notFound) }
        
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
        try await findArticle(req: req)
    }
    
    /// Update the Article withing the table
    func update(req: Request) async throws -> Article {
        let identifiedArticle = try await findArticle(req: req)
        let updatedArticleDTO = try req.content.decode(ArticleUpdate.self)
        
        identifiedArticle.update(with: updatedArticleDTO)
        
        try await identifiedArticle.update(on: req.db)
        
        return identifiedArticle
    }
    
    /// Delete the Article within the table.
    func delete(req: Request) async throws -> HTTPStatus {
        guard let identifiedArticle = try await Article.find(req.parameters.get("id"), on: req.db) else { throw Abort(.notFound) }
        try await identifiedArticle.delete(on: req.db)
        return .ok
    }
    
    // MARK: - Private Helpers
    
    private func findArticle(req: Request) async throws -> Article {
        guard
            let identifiedArticle = try await Article.find(req.parameters.get("id"), on: req.db)
        else { throw Abort(.notFound) }
        
        return identifiedArticle
    }

    
}
