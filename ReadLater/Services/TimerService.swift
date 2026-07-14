import Foundation
import Observation

@Observable @MainActor
final class TimerService {
    private(set) var isRunning = false
    private(set) var elapsed: TimeInterval = 0
    private var startedAt: Date?
    private let now: () -> Date
    init(now: @escaping () -> Date = Date.init) { self.now = now }
    func start() { guard !isRunning else { return }; startedAt = now(); isRunning = true }
    func pause() { guard isRunning, let startedAt else { return }; elapsed += max(0, now().timeIntervalSince(startedAt)); self.startedAt = nil; isRunning = false }
    func reset() { isRunning = false; elapsed = 0; startedAt = nil }
    var currentElapsed: TimeInterval { elapsed + (isRunning ? max(0, now().timeIntervalSince(startedAt ?? now())) : 0) }
}
