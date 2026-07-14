import Foundation
struct SharedURLInbox {
    private static let groupID = "group.com.example.ReadLater"
    private static let key = "pendingSharedURLs"
    func consume() -> [URL] {
        guard let defaults = UserDefaults(suiteName: Self.groupID) else { return [] }
        let values = defaults.stringArray(forKey: Self.key) ?? []
        defaults.removeObject(forKey: Self.key)
        return values.compactMap(URL.init(string:)).filter { ["http", "https"].contains($0.scheme?.lowercased() ?? "") && $0.host != nil }
    }
}
