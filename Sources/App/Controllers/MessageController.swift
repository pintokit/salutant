import Fluent
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let messages = routes.grouped("messages")
        
        // Show list of messages (index)
        messages.get(use: index)
        
        // Show the "create new message" form
        messages.get("create", use: showCreateForm)
        
        // Handle the JSON POST submission (create the new message)
        messages.post(use: createMessage)
        
        messages.group(":messageID") { message in
            message.get("edit", use: editMessage)
            message.put(use: updateMessage)
            message.delete(use: deleteMessage)
        }
    }
    
    // MARK: - Context Structs
    
    struct IndexContext: Encodable {
        let messages: [MessageDTO]
    }
    
    struct MessageContext: Encodable {
        let title: String
        let message: MessageData
        
        struct MessageData: Encodable {
            let id: String
            let sender: String
            let content: String
        }
    }
    
    // MARK: - Index
    
    @Sendable
    func index(req: Request) async throws -> View {
        let messages = try await Message.query(on: req.db).all()
        let messageDTOs = messages.map { $0.toDTO() }
        
        let context = IndexContext(messages: messageDTOs)
        return try await req.view.render("index", context)
    }
    
    // MARK: - Create (Form + Handler)
    
    /// GET /messages/create
    /// Renders your `message-create.leaf` template so the user can fill out a new message form.
    @Sendable
    func showCreateForm(req: Request) async throws -> View {
        // Minimal context—e.g., a title for your page:
        let context = ["title": "Create New Message"]
        return try await req.view.render("message-create", context)
    }
    
    /// POST /messages
    /// Decodes JSON body into a `MessageDTO`, saves it, then redirects to the index.
    @Sendable
    func createMessage(req: Request) async throws -> Response {
        let dto: MessageDTO
        do {
            // First attempt: decode based on the header or default to JSON
            dto = try req.content.decode(MessageDTO.self)
        } catch {
            // If that fails, forcibly try URL-encoded form decoding
            dto = try req.content.decode(MessageDTO.self, using: URLEncodedFormDecoder())
        }
        
        let message = dto.toModel()
        try await message.save(on: req.db)
        return req.redirect(to: "/messages")
    }
    
    // MARK: - Edit / Update
    
    /// GET /messages/:messageID/edit
    /// Renders the `message-update.leaf` template with existing message data.
    @Sendable
    func editMessage(req: Request) async throws -> View {
        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let context = MessageContext(
            title: "Edit Message",
            message: MessageContext.MessageData(
                id: message.id?.uuidString ?? "",
                sender: message.sender,
                content: message.content
            )
        )
        
        return try await req.view.render("message-update", context)
    }
    
    /// PUT /messages/:messageID
    /// Decodes JSON (or form data) into `MessageDTO`, updates the existing message, redirects.
    @Sendable
    func updateMessage(req: Request) async throws -> Response {
        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let input = try req.content.decode(MessageDTO.self)
        message.sender = input.sender
        message.content = input.content
        try await message.save(on: req.db)
        
        return req.redirect(to: "/messages")
    }
    
    // MARK: - Delete
    
    /// DELETE /messages/:messageID
    /// Deletes a message and returns HTTP 204 on success.
    @Sendable
    func deleteMessage(req: Request) async throws -> HTTPStatus {
        guard let message = try await Message.find(req.parameters.get("messageID"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await message.delete(on: req.db)
        return .noContent
    }
}
