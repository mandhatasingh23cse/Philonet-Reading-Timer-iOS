import SwiftUI
import WebKit
struct WebView: UIViewRepresentable {
    let url: URL; @Binding var isLoading: Bool; @Binding var errorMessage: String?
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    func makeUIView(context: Context) -> WKWebView { let view = WKWebView(); view.navigationDelegate = context.coordinator; view.allowsBackForwardNavigationGestures = true; view.load(URLRequest(url: url)); return view }
    func updateUIView(_ view: WKWebView, context: Context) {}
    final class Coordinator: NSObject, WKNavigationDelegate { let parent: WebView; init(_ parent: WebView) { self.parent = parent }; func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { parent.isLoading = false }; func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { parent.isLoading = false; parent.errorMessage = error.localizedDescription }; func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { parent.isLoading = false; parent.errorMessage = error.localizedDescription } }
}
