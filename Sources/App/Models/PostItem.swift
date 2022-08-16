//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

final class PostItem: Model, Content {
    var id = UUID?
    var title: String
    var description: String
    var author: User.ID
    var tags: [String]
    var url: String
    var content: String
    
    init() { }
    init(id: UUID = UUID(), title: String, description: String, author: User.IDValue, tags: [String], url: String, content: String) {
        self.id = id
        self.title = title
        self.description = description
        self.author = author
        self.tags = tags
        self.url = url
        self.content = content
    }
}
