import Foundation

struct SharedURLInbox {
    private static let groupID = "group.com.example.ReadLater"
    private static let key = "pendingSharedURLs"
    func enqueue(_ url: URL) {
        guard let defaults = UserDefaults(suiteName: Self.groupID) else { return }
        var values = defaults.stringArray(forKey: Self.key) ?? []
        guard !values.contains(url.absoluteString) else { return }
        values.append(url.absoluteString)
        defaults.set(values, forKey: Self.key)
    }
}
