import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in instanceID.uuidString }

    try app.register(collection: UserController())
    try app.register(collection: ArticleController())
    try app.register(collection: AuthenticationController())
}
