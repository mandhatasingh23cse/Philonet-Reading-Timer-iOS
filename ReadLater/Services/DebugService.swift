import Foundation
import Observation
@Observable @MainActor final class DebugService {
    private(set) var events: [DebugEvent] = []
    private(set) var memoryTime: TimeInterval = 0
    private(set) var persistedTime: TimeInterval = 0
    private(set) var mergedTime: TimeInterval = 0
    private(set) var currentSession: TimeInterval = 0
    private(set) var timerRunning = false
    private(set) var lastMergeRule = MergeRule.noChange
    func updateTimer(memory: TimeInterval, persisted: TimeInterval, merged: TimeInterval, running: Bool, rule: MergeRule) { memoryTime = memory; persistedTime = persisted; mergedTime = max(persisted, merged); currentSession = memory; timerRunning = running; lastMergeRule = rule }
    func record(_ kind: DebugEvent.Kind, _ message: String) { events.insert(DebugEvent(date: .now, kind: kind, message: message), at: 0); if events.count > 100 { events.removeLast() } }
}
