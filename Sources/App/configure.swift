import Fluent
import FluentPostgresDriver
import Vapor

let instanceID: UUID = UUID()

// configures your application
public func configure(_ app: Application) throws {
    // MARK: - CORSMiddleware
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let corsMiddleware = CORSMiddleware(configuration: corsConfiguration)
    
    app.middleware.use(corsMiddleware)
    
    // MARK: - FileMiddleware
    
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // MARK: - SessionsMiddleware
    
    app.sessions.configuration.cookieFactory = { sessionID in
            .init(
                string: sessionID.string,
                expires: Date().addingTimeInterval(60 * 60 * 3),
                isSecure: true,
                isHTTPOnly: true
            )
    }
    app.middleware.use(app.sessions.middleware)
    
    // MARK: - User SessionAuthenticatable Middleware
    
    app.middleware.use(User.sessionAuthenticator())
    
    // MARK: - Database Configuration
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        app.databases.use(
            .postgres(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "oneleif_dev",
                password: Environment.get("DATABASE_PASSWORD") ?? "oneleif_password",
                database: Environment.get("DATABASE_NAME") ?? "vapor_database"
            ),
            as: .psql
        )
    }
    
    // MARK: - Migrations
    
    app.migrations.add(
        User.Migration(),
        Article.Migration(),
        UserArticlePivot.Migration()
    )
    
    try app.autoMigrate().wait()
    
    // MARK: - Routes
    
    try routes(app)
}
