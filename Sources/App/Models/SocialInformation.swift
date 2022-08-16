//
//  File.swift
//  
//
//  Created by Rob Maltese on 8/16/22.
//

import Fluent
import Vapor


final class SocialInformation: Model, Content {
    var id: UUID?
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var discordUsername: String
    var githubUsername: String
    var tags: [String]
    var profileImage: String
    var biography: String
    var links: [String]
    var location: String
    
    init() { }
    init(id: UUID? = UUID(), username: String, fistName: String, lastName: String, email: String, discordUsername: String, githubUsername: String, tags: [String], profileImage: String, biography: String, links: [String], location: String) {
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
    }
}
