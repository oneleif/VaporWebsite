//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor


final class SocialInformation: Model, Content {
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "firstName")
    var firstName: String
    
    @Field(key: "lastName")
    var lastName: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "discordUsername")
    var discordUsername: String
    
    @Field(key: "githubUsername")
    var githubUsername: String
    
    @Field(key: "tags")
    var tags: [String]
    
    @Field(key: "profileImage")
    var profileImage: String
    
    @Field(key: "biography")
    var biography: String
    
    @Field(key: "links")
    var links: [String]
    
    @Field(key: "location")
    var location: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    init(id: UUID? = UUID(), username: String, fistName: String, lastName: String, email: String, discordUsername: String, githubUsername: String, tags: [String], profileImage: String, biography: String, links: [String], location: String, user: User.IDValue) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.discordUsername = discordUsername
        self.githubUsername = githubUsername
        self.tags = tags
        self.profileImage = profileImage
        self.biography = biography
        self.links = links
        self.location = location
        self.$user.id = user_id
    }
}
