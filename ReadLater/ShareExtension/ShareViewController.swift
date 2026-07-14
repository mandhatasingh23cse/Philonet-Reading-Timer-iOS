import Social
import UniformTypeIdentifiers

final class ShareViewController: SLComposeServiceViewController {
    private let inbox = SharedURLInbox()
    private var sharedURL: URL?

    override func isContentValid() -> Bool { sharedURL != nil }

    override func didSelectPost() {
        guard let sharedURL else { cancelWithError("No valid web address was supplied."); return }
        inbox.enqueue(sharedURL)
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Save to Read Later"
        loadURL()
    }

    private func loadURL() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier(UTType.url.identifier) }) else {
            cancelWithError("This item does not contain a URL."); return
        }
        provider.loadItem(forTypeIdentifier: UTType.url.identifier) { [weak self] item, error in
            DispatchQueue.main.async {
                guard error == nil, let url = item as? URL, Self.isHTTPURL(url) else { self?.cancelWithError("Only HTTP and HTTPS URLs can be saved."); return }
                self?.sharedURL = url
                self?.textView.text = url.absoluteString
                self?.validateContent()
            }
        }
    }

    private static func isHTTPURL(_ url: URL) -> Bool { ["http", "https"].contains(url.scheme?.lowercased() ?? "") && url.host != nil }
    private func cancelWithError(_ description: String) { extensionContext?.cancelRequest(withError: NSError(domain: "ReadLaterShare", code: 1, userInfo: [NSLocalizedDescriptionKey: description])) }
}
