import Foundation
import Observation
@Observable @MainActor final class ReaderViewModel {
    let article: Article; let timer: TimerService
    private let repository: ArticleRepository; private let merger: MergeServiceProtocol; private let debug: DebugService
    private var checkpoint: TimeInterval = 0; private var persistedBase: TimeInterval
    var lastMergeRule = MergeRule.noChange
    init(article: Article, repository: ArticleRepository, debug: DebugService, timer: TimerService = TimerService(), merger: MergeServiceProtocol = MergeService()) { self.article = article; self.repository = repository; self.debug = debug; self.timer = timer; persistedBase = article.totalReadingTime }
    func appear(isActive: Bool) { if isActive { timer.start(); debug.record(.timer, "Reader timer started") }; updateDebug() }
    func disappear() { timer.pause(); persist() }
    func lifecycleChanged(active: Bool) { if active { timer.start() } else { timer.pause(); persist() }; updateDebug() }
    func persist() {
        timer.pause()
        let result = merger.merge(persisted: persistedBase, memory: timer.currentElapsed, lastPersistedSessionDuration: checkpoint)
        guard result.sessionIncrement > 0 else { updateDebug(); return }
        do { try repository.updateReadingTime(article: article, total: result.total, lastRead: .now); persistedBase = result.total; checkpoint = timer.currentElapsed; lastMergeRule = result.rule; debug.record(.merge, result.rule.rawValue) } catch { debug.record(.error, "Reading time save failed: \(error.localizedDescription)") }; updateDebug()
    }
    var total: TimeInterval { persistedBase + max(0, timer.currentElapsed - checkpoint) }
    private func updateDebug() { debug.updateTimer(memory: timer.currentElapsed, persisted: persistedBase, merged: total, running: timer.isRunning, rule: lastMergeRule) }
}
