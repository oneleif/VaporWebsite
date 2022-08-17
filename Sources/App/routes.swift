import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { _ in instanceID.uuidString }

    try app.register(collection: UserController())
<<<<<<< HEAD
    try app.register(collection: ArticleController())
=======
    try app.register(collection: AuthenticationController())
>>>>>>> 718bb29 (Added AuthenticationController to the routes, moved more auth logic out of the UserController and began creating the login function.)
}
