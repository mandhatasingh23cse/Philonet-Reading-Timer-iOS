import Foundation
import SwiftData

enum RepositoryError: LocalizedError { case invalidURL; case missingArticle; var errorDescription: String? { switch self { case .invalidURL: "The URL is invalid."; case .missingArticle: "The article no longer exists." } } }
protocol ArticleRepository: Sendable { @MainActor func all() throws -> [Article]; @MainActor func save(url: URL, title: String) throws -> Article; @MainActor func delete(_ article: Article) throws; @MainActor func updateReadingTime(article: Article, total: TimeInterval, lastRead: Date) throws }
@MainActor final class SwiftDataArticleRepository: ArticleRepository {
    private let context: ModelContext
    private let storage: StorageService
    init(context: ModelContext, storage: StorageService? = nil) { self.context = context; self.storage = storage ?? SwiftDataStorageService(context: context) }
    func all() throws -> [Article] { try context.fetch(FetchDescriptor<Article>(sortBy: [SortDescriptor(\Article.updatedAt, order: .reverse)])) }
    func save(url: URL, title: String) throws -> Article {
        guard ["http", "https"].contains(url.scheme?.lowercased() ?? ""), url.host != nil else { throw RepositoryError.invalidURL }
        let urlString = url.absoluteString
        let descriptor = FetchDescriptor<Article>(predicate: #Predicate { $0.urlString == urlString })
        if let existing = try context.fetch(descriptor).first { return existing }
        let article = Article(urlString: url.absoluteString, title: title)
        context.insert(article); try storage.save(); return article
    }
    func delete(_ article: Article) throws { context.delete(article); try storage.save() }
    func updateReadingTime(article: Article, total: TimeInterval, lastRead: Date) throws { article.totalReadingTime = max(article.totalReadingTime, total); article.lastReadDate = lastRead; article.updatedAt = lastRead; try storage.save() }
}
