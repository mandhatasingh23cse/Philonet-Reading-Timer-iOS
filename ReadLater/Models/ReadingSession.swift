import Foundation
import SwiftData

@Model
final class ReadingSession {
    @Attribute(.unique) var id: UUID
    var articleID: UUID
    var startedAt: Date
    var accumulatedBeforeSession: TimeInterval
    var lastCheckpointAt: Date?
    var isRunning: Bool
    init(articleID: UUID, startedAt: Date = .now, accumulatedBeforeSession: TimeInterval, lastCheckpointAt: Date? = .now, isRunning: Bool = true) { id = UUID(); self.articleID = articleID; self.startedAt = startedAt; self.accumulatedBeforeSession = accumulatedBeforeSession; self.lastCheckpointAt = lastCheckpointAt; self.isRunning = isRunning }
}
