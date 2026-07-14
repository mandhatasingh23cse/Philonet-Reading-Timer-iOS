import Foundation
import Observation
@Observable @MainActor final class HomeViewModel {
    private let repository: ArticleRepository; private let debug: DebugService
    var articles: [Article] = []; var errorMessage: String?
    init(repository: ArticleRepository, debug: DebugService) { self.repository = repository; self.debug = debug }
    func reload() { do { articles = try repository.all() } catch { errorMessage = error.localizedDescription; debug.record(.error, "Loading articles failed: \(error.localizedDescription)") } }
    func delete(_ article: Article) { do { try repository.delete(article); reload(); debug.record(.storage, "Deleted article") } catch { errorMessage = error.localizedDescription } }
}
