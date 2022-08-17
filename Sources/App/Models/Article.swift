//
//  Article.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

/// Article Model
///
/// This outlines the model of each article post. Additionally, it creates the relationship between the parent which will be the user.
final class Article: Model, Content {
    static var schema = "articles"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Parent(key: "author_id")
    var author: User
    
    @Field(key: "tags")
    var tags: [String]
    
    @Field(key: "url")
    var url: String
    
    @Field(key: "content")
    var content: String

    @Siblings(through: UserArticlePivot.self, from: \.$article, to: \.$user)
    var coauthors: [User]
    
    @Timestamp(key: "postDate", on: .create)
    var postDate: Date?
    
    init() { }
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        author: User.IDValue,
        tags: [String],
        url: String,
        content: String,
        postDate: Date?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.$author.id = author
        self.tags = tags
        self.url = url
        self.content = content
        self.postDate = postDate
    }
}

// MARK: - DTO

// POST: Input

struct ArticleCreate: Content {
    let title: String
    let description: String
    let author: User.IDValue
    let tags: [String]
    let url: String
    let content: String
    let coauthors: [User.IDValue]
    let postDate: Date?
}

// PUT: Input

struct ArticleUpdate: Content {
    let id: UUID
    let title: String
    let description: String
    let author: User
    let tags: [String]
    let url: String
    let content: String
    let coauthors: [User]
    let postDate: Date?
}

extension Article {
    func update(with articleUpdate: ArticleUpdate) {
        title = articleUpdate.title
        description = articleUpdate.description
        author = articleUpdate.author
        tags = articleUpdate.tags
        url = articleUpdate.url
        content = articleUpdate.content
        coauthors = articleUpdate.coauthors
        postDate = articleUpdate.postDate
    }
}
