import Fluent
import Vapor

struct MessageDTO: Content {
    var id: UUID?
    var sender: String
    var content: String
    
    func toModel() -> Message {
        return Message(id: id, sender: sender, content: content)
    }
}
