import Foundation

protocol MergeServiceProtocol: Sendable { func merge(persisted: TimeInterval, memory: TimeInterval, lastPersistedSessionDuration: TimeInterval) -> MergeResult }
struct MergeService: MergeServiceProtocol {
    /// `memory` is the session's observed duration; its checkpoint is subtracted before comparing, preventing replay after a crash.
    func merge(persisted: TimeInterval, memory: TimeInterval, lastPersistedSessionDuration: TimeInterval) -> MergeResult {
        let safePersisted = max(0, persisted), safeMemory = max(0, memory), checkpoint = min(max(0, lastPersistedSessionDuration), safeMemory)
        let unpersisted = safeMemory - checkpoint
        guard unpersisted > 0 else { return MergeResult(total: safePersisted, sessionIncrement: 0, rule: .noChange) }
        let total = safePersisted + unpersisted
        return MergeResult(total: total, sessionIncrement: unpersisted, rule: checkpoint > 0 ? .checkpointApplied : .persistedWins)
    }
}
