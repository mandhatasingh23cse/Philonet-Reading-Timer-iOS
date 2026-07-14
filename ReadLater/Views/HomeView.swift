import SwiftUI
import UIKit
struct HomeView: View {
    @State var viewModel: HomeViewModel
    @Environment(AppEnvironment.self) private var environment
    var body: some View {
        NavigationStack {
            Group { if viewModel.articles.isEmpty { ContentUnavailableView("No Saved Articles", systemImage: "bookmark", description: Text("Share a webpage from Safari to save it here.")) } else { List { ForEach(viewModel.articles) { article in NavigationLink(value: article.id) { ArticleRow(article: article) }.swipeActions { Button(role: .destructive) { viewModel.delete(article) } label: { Label("Delete", systemImage: "trash") } }.contextMenu { Button { UIPasteboard.general.string = article.urlString } label: { Label("Copy URL", systemImage: "doc.on.doc") } } } } } }
                .navigationTitle("Read Later").navigationDestination(for: UUID.self) { id in if let article = viewModel.articles.first(where: { $0.id == id }) { ReaderView(viewModel: ReaderViewModel(article: article, repository: environment.repository, debug: environment.debug)) } }
                .toolbar { ToolbarItem(placement: .topBarTrailing) { NavigationLink { DebugView(debug: environment.debug) } label: { Image(systemName: "ladybug") }.accessibilityLabel("Open debug panel") } }
                .refreshable { await environment.importSharedURLs(); viewModel.reload() }
                .task { await environment.importSharedURLs(); viewModel.reload() }
                .onChange(of: environment.lifecycle.phase) { _, _ in viewModel.reload() }
                .alert("Something went wrong", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) { Button("OK", role: .cancel) {} } message: { Text(viewModel.errorMessage ?? "") }
        }
    }
}
