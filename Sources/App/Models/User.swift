//
//  User.swift
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
    
    @Siblings(through: UserArticlePivot.self, from: \.$user, to: \.$article)
    var articles: [Article]
    
    // MARK: - Social Information
    
    @OptionalField(key: "firstName")
    var firstName: String?
    
    @OptionalField(key: "lastName")
    var lastName: String?
    
    @OptionalField(key: "discordUsername")
    var discordUsername: String?
    
    @OptionalField(key: "githubUsername")
    var githubUsername: String?
    
    @Field(key: "tags")
    var tags: [String]
    
    @Field(key: "links")
    var links: [String]
    
    @OptionalField(key: "profileImage")
    var profileImage: String?
    
    @OptionalField(key: "biography")
    var biography: String?

    @OptionalField(key: "location")
    var location: String?
    
    init() { }
    
    init(
        id: UUID? = UUID(),
        email: String,
        password: String,
        firstName: String?,
        lastName: String?,
        discordUsername: String?,
        githubUsername: String?,
        tags: [String],
        links: [String],
        profileImage: String?,
        biography: String?,
        location: String?
    ) {
        self.id = id
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.discordUsername = discordUsername
        self.githubUsername = githubUsername
        self.tags = tags
        self.links = links
        self.profileImage = profileImage
        self.biography = biography
        self.location = location
    }
}

// MARK: - DTO

// PUT: Input

struct UserSocialUpdate: Content {
    let id: UUID
    let firstName: String?
    let lastName: String?
    let discordUsername: String?
    let githubUsername: String?
    let profileImage: String?
    let location: String?
    let biography: String?
    let tags: [String]
    let links: [String]
}

extension User {
    func update(with userSocialUpdate: UserSocialUpdate) {
        firstName = userSocialUpdate.firstName
        lastName = userSocialUpdate.lastName
        discordUsername = userSocialUpdate.discordUsername
        githubUsername = userSocialUpdate.githubUsername
        profileImage = userSocialUpdate.profileImage
        location = userSocialUpdate.location
        biography = userSocialUpdate.biography
        tags = userSocialUpdate.tags
        links = userSocialUpdate.links
    }
}

// Output

struct UserDTO: Content {
    let id: String
    let email: String?
    let articles: [UUID]
    let firstName: String?
    let lastName: String?
    let discordUsername: String?
    let githubUserName: String?
    let profileImage: String?
    let location: String?
    let biography: String?
    let tags: [String]
    let links: [String]
}


extension User {
    func dto(on database: Database) async throws -> UserDTO {
        UserDTO(
            id: id?.uuidString ?? "-1",
            email: email,
            articles: try await $articles.get(on: database).compactMap(\.id),
            firstName: firstName,
            lastName: lastName,
            discordUsername: discordUsername,
            githubUserName: githubUsername,
            profileImage: profileImage,
            location: location,
            biography: biography,
            tags: tags,
            links: links
        )
    }
}


