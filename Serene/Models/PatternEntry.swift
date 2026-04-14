import Foundation
import SwiftData

@Model
final class PatternEntry {
    var id: UUID
    var type: String // "topic", "emotion", "connection"
    var content: String
    var detectedAt: Date
    var acknowledged: Bool

    init(
        id: UUID = UUID(),
        type: String = "topic",
        content: String = "",
        detectedAt: Date = Date(),
        acknowledged: Bool = false
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.detectedAt = detectedAt
        self.acknowledged = acknowledged
    }
}
