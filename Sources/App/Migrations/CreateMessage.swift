import Fluent

struct CreateMessage: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("messages")
            .field("id", .uuid, .identifier(auto: .random()))
            .field("sender", .string, .required)
            .field("content", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("messages").delete()
    }
}
