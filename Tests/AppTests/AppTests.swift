@testable import App
import XCTVapor
import Fluent

final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        // Create a test Application using your custom factory or standard init
        self.app = try await Application.make(.testing)
        try await configure(app)
        // Run migrations so your test DB schema is ready
        try await app.autoMigrate()
    }
    
    override func tearDown() async throws {
        // Revert migrations (clean up) and shut down the app
        try await app.autoRevert()
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    // MARK: - Messages Tests
    
    func testMessageIndex() async throws {
        // Insert some sample messages directly into the DB
        let sampleMessages = [
            Message(sender: "Alice", content: "First message"),
            Message(sender: "Bob",   content: "Second message")
        ]
        try await sampleMessages.create(on: self.app.db)
        
        // Call GET /messages
        try await self.app.test(.GET, "messages", afterResponse: { res async throws in
            XCTAssertEqual(res.status, .ok)
            
            // Decode the response as an array of MessageDTO
            let fetchedDTOs = try res.content.decode([MessageDTO].self)
            
            // Convert the original models to DTOs and compare
            let expectedDTOs = sampleMessages.map { $0.toDTO() }
            
            // Sort if needed (so we compare in a consistent order)
            XCTAssertEqual(
                fetchedDTOs.sorted { $0.sender < $1.sender },
                expectedDTOs.sorted { $0.sender < $1.sender }
            )
        })
    }
    
    func testMessageCreate() async throws {
        // Construct the DTO we want to send
        let newDTO = MessageDTO(id: nil, sender: "Charlie", content: "Hello from Charlie")
        
        // Call POST /messages with JSON body
        try await self.app.test(.POST, "messages", beforeRequest: { req in
            try req.content.encode(newDTO)
        }, afterResponse: { res async throws in
            // Depending on your route, you might get .ok or a redirect (3xx).
            XCTAssertEqual(res.status, .ok)
            
            // Fetch messages from the DB and confirm it was created
            let stored = try await Message.query(on: self.app.db).all()
            XCTAssertEqual(stored.count, 1)
            XCTAssertEqual(stored.first?.sender, newDTO.sender)
            XCTAssertEqual(stored.first?.content, newDTO.content)
        })
    }
    
    func testMessageDelete() async throws {
        // Create two messages in the DB
        let messages = [
            Message(sender: "David", content: "Temp 1"),
            Message(sender: "Erin",  content: "Temp 2")
        ]
        try await messages.create(on: app.db)
        
        // Delete the first message: DELETE /messages/:id
        try await self.app.test(.DELETE, "messages/\(messages[0].requireID())", afterResponse: { res async throws in
            // Expect a 204 No Content
            XCTAssertEqual(res.status, .noContent)
            
            // Verify the message was indeed deleted
            let remaining = try await Message.query(on: self.app.db).all()
            XCTAssertEqual(remaining.count, 1)
            XCTAssertEqual(remaining[0].sender, "Erin")
        })
    }
}

// MARK: - Equatable Conformance
// If you compare MessageDTO arrays in your tests, add Equatable to your DTO:
extension MessageDTO: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.sender == rhs.sender && lhs.content == rhs.content
    }
}
