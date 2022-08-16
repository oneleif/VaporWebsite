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
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @OptionalChild(for: \.$user)
    var social: SocialInformation?
    
    @OptionalChild(for: \.$user)
    var post: PostItem?
    
    init() { } 
    init(id: UUID? = UUID(), email: String, password: String, social: SocialInformation?, post: PostItem?) {
        self.id = id
        self.email = email
        self.password = password
        self.$social = social
        self.$post.id = post
    }
}
