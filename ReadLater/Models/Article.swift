import Foundation
import SwiftData

@Model
final class Article {
    @Attribute(.unique) var id: UUID
    var urlString: String
    var title: String
    var totalReadingTime: TimeInterval
    var lastReadDate: Date?
    var createdAt: Date
    var updatedAt: Date
    init(id: UUID = UUID(), urlString: String, title: String, totalReadingTime: TimeInterval = 0, lastReadDate: Date? = nil, createdAt: Date = .now, updatedAt: Date = .now) { self.id = id; self.urlString = urlString; self.title = title; self.totalReadingTime = totalReadingTime; self.lastReadDate = lastReadDate; self.createdAt = createdAt; self.updatedAt = updatedAt }
    var url: URL? { URL(string: urlString) }
}
