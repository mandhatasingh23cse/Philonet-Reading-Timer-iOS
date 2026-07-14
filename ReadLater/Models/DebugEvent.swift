import Foundation
struct DebugEvent: Identifiable, Sendable { enum Kind: String, Sendable { case lifecycle, storage, timer, merge, error }; let id = UUID(); let date: Date; let kind: Kind; let message: String }
