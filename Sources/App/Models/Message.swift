import Vapor
import Fluent

final class Message: Model, @unchecked Sendable {
    static let schema = "messages"
    
    @ID(custom: "id", generatedBy: .random)
    var id: UUID?
    
    @Field(key: "sender")
    var sender: String
    
    @Field(key: "content")
    var content: String
    
    init() { }
    
    init(id: UUID? = nil, sender: String, content: String) {
        self.id = id
        self.sender = sender
        self.content = content
    }
    
    func toDTO() -> MessageDTO {
        return MessageDTO(id: self.id, sender: self.sender, content: self.content)
    }
}

extension Message: Content { }
