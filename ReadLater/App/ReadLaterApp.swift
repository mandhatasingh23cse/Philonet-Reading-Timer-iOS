import SwiftUI
import SwiftData
import Observation

@main
struct ReadLaterApp: App {
    private let container: ModelContainer
    @State private var environment: AppEnvironment

    init() {
        let modelContainer: ModelContainer
        do { modelContainer = try ModelContainer(for: Article.self, ReadingSession.self) }
        catch { fatalError("Unable to initialize local article storage: \(error.localizedDescription)") }
        self.container = modelContainer
        _environment = State(initialValue: AppEnvironment(container: modelContainer))
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(repository: environment.repository, debug: environment.debug))
                .environment(environment)
                .task { await environment.importSharedURLs() }
                .onChange(of: environment.lifecycle.phase) { _, phase in environment.handleScenePhase(phase) }
        }
        .modelContainer(container)
    }
}

@Observable @MainActor
final class AppEnvironment {
    let repository: ArticleRepository
    let debug = DebugService()
    let lifecycle = LifecycleService()
    let sharedInbox = SharedURLInbox()
    init(container: ModelContainer) { repository = SwiftDataArticleRepository(context: ModelContext(container)) }
    func importSharedURLs() async {
        for url in sharedInbox.consume() { do { _ = try repository.save(url: url, title: url.host ?? url.absoluteString); debug.record(.storage, "Imported shared URL: \(url.host ?? url.absoluteString)") } catch { debug.record(.error, "Share import failed: \(error.localizedDescription)") } }
    }
    func handleScenePhase(_ phase: ScenePhase) { lifecycle.phase = phase; debug.record(.lifecycle, "Scene phase: \(String(describing: phase))") }
}
