import SwiftUI
import UIKit
struct ReaderView: View {
    @State var viewModel: ReaderViewModel
    @Environment(AppEnvironment.self) private var environment
    @State private var loading = true
    @State private var loadError: String?
    var body: some View { VStack(spacing: 0) { if let url = viewModel.article.url { WebView(url: url, isLoading: $loading, errorMessage: $loadError).overlay { if loading { ProgressView("Loading article") } } } else { ContentUnavailableView("Invalid URL", systemImage: "exclamationmark.triangle") }; Divider(); TimelineView(.periodic(from: .now, by: 1)) { _ in HStack { metric("Session", viewModel.timer.currentElapsed.readingDisplay); metric("Total", viewModel.total.readingDisplay); VStack(alignment: .trailing) { Text(viewModel.timer.isRunning ? "Reading" : "Paused").font(.caption).foregroundStyle(viewModel.timer.isRunning ? .green : .secondary); Text(viewModel.lastMergeRule.rawValue).font(.caption2).foregroundStyle(.secondary).lineLimit(1) } }.padding().background(.bar) } }.navigationTitle(viewModel.article.title).navigationBarTitleDisplayMode(.inline).onAppear { viewModel.appear(isActive: environment.lifecycle.isActive) }.onDisappear { viewModel.disappear() }.onChange(of: environment.lifecycle.phase) { _, phase in viewModel.lifecycleChanged(active: phase == .active) }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in viewModel.disappear() }.alert("Page could not load", isPresented: Binding(get: { loadError != nil }, set: { if !$0 { loadError = nil } })) { Button("Retry") { loading = true }; Button("OK", role: .cancel) {} } message: { Text(loadError ?? "Check your internet connection and try again.") } }
    private func metric(_ name: String, _ value: String) -> some View { VStack(alignment: .leading) { Text(name).font(.caption).foregroundStyle(.secondary); Text(value).font(.headline.monospacedDigit()) } }
}
