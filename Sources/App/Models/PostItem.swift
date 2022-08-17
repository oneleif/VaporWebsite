//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

/// Post Model
///
/// This outlines the model of each article post. Additionally, it creates the relationship between the parent which will be the user.
final class PostItem: Model, Content {
    static var schema = "posts"
    
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

    #warning("TODO - Swap this over to a sibling relationship - many to many?")
    @Parent(key: "coauthor_id")
    var coauthors: [User]
    
    @Timestamp(key: "postDate", on: .create)
    var postDate: Date?
    
    init() { }
    init(id: UUID = UUID(), title: String, description: String, author: User.IDValue, tags: [String], url: String, content: String, coAuthors: [User.IDValue], postDate: Date?) {
        self.id = id
        self.title = title
        self.description = description
        self.$author.id = author
        self.tags = tags
        self.url = url
        self.content = content
        self.$coAuthors.id = coAuthors
        self.postDate = postDate
    }
}

