import XCTest
import SwiftData
@testable import ReadLater

@MainActor final class ReadLaterTests: XCTestCase {
    func testTimerDoesNotDoubleStart() { var date = Date(timeIntervalSince1970: 0); let timer = TimerService(now: { date }); timer.start(); date.addTimeInterval(10); timer.start(); timer.pause(); XCTAssertEqual(timer.elapsed, 10) }
    func testMergeAppliesOnlyDurationAfterCheckpoint() { let result = MergeService().merge(persisted: 100, memory: 30, lastPersistedSessionDuration: 20); XCTAssertEqual(result.total, 110); XCTAssertEqual(result.sessionIncrement, 10) }
    func testMergeNeverDecreasesPersistedTime() { XCTAssertEqual(MergeService().merge(persisted: 42, memory: 4, lastPersistedSessionDuration: 4).total, 42) }
    func testStorageSavesInsertedArticle() throws { let container = try ModelContainer(for: Article.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)); let context = ModelContext(container); context.insert(Article(urlString: "https://example.com", title: "Example")); XCTAssertNoThrow(try SwiftDataStorageService(context: context).save()) }
    func testRepositorySavesAndReturnsArticle() throws { let container = try ModelContainer(for: Article.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)); let repository = SwiftDataArticleRepository(context: ModelContext(container)); let article = try repository.save(url: try XCTUnwrap(URL(string: "https://example.com")), title: "Example"); XCTAssertEqual(article.title, "Example") }
    func testRepositoryRejectsInvalidURL() async throws { let container = try ModelContainer(for: Article.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)); let repository = SwiftDataArticleRepository(context: ModelContext(container)); await XCTAssertThrowsErrorAsync { try await repository.save(url: URL(string: "file:///a")!, title: "Bad") } }
}

func XCTAssertThrowsErrorAsync<T>(_ expression: @escaping () async throws -> T, file: StaticString = #filePath, line: UInt = #line) async { do { _ = try await expression(); XCTFail("Expected error", file: file, line: line) } catch {} }
