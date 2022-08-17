import Fluent
import Vapor

final class UserPost: Model {
    static let schema = "user+post"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "post_id")
    var post: Post

    init() { }

    init(id: UUID? = nil, user: User, post: Post) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$post.id = try post.requireID()
    }
}
