import Foundation
import SwiftData

protocol StorageService: Sendable { @MainActor func save() throws }
@MainActor final class SwiftDataStorageService: StorageService {
    private let context: ModelContext
    init(context: ModelContext) { self.context = context }
    func save() throws { if context.hasChanges { try context.save() } }
}
