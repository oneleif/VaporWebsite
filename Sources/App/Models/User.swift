//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor

/// User Model
///
/// This outlines the User Model. Additionally, it creates an optional child for the social information.
final class User: Model, Content {
    static var schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Children(for: \.$author)
    var post: [PostItem]?
    
    // MARK: - Social Information
    
    @OptionalField(key: "firstName")
    var firstName: String?
    
    @OptionalField(key: "lastName")
    var lastName: String?
    
    @OptionalField(key: "discordUsername")
    var discordUsername: String?
    
    @OptionalField(key: "githubUsername")
    var githubUsername: String?
    
    @OptionalField(key: "tags")
    var tags: [String]?
    
    @OptionalField(key: "profileImage")
    var profileImage: String?
    
    @OptionalField(key: "biography")
    var biography: String?
    
    @OptionalField(key: "links")
    var links: [String]?
    
    @OptionalField(key: "location")
    var location: String?
    
    init() { } 
    init(id: UUID? = UUID(), email: String, password: String, post: [PostItem]?) {
        self.id = id
        self.email = email
        self.password = password
        self.$social.id = social
        self.$post.id = post
    }
}
