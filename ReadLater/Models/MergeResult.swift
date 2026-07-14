import Foundation
struct MergeResult: Sendable, Equatable { let total: TimeInterval; let sessionIncrement: TimeInterval; let rule: MergeRule }
enum MergeRule: String, Sendable { case persistedWins = "Persisted value was newer/larger"; case checkpointApplied = "Applied unpersisted checkpoint"; case noChange = "No newer duration available" }
