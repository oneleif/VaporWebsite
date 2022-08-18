import Fluent
import Vapor

final class UserArticlePivot: Model {
    static let schema = "user+article"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "article_id")
    var article: Article

    init() { }

    init(id: UUID? = nil, user: User, article: Article) throws {
        self.id = id
        self.$user.id = try user.requireID()
        self.$article.id = try article.requireID()
    }
}
