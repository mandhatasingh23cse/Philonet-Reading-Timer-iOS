import Foundation
extension TimeInterval { var readingDisplay: String { let seconds = Int(self.rounded(.down)); return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, seconds % 60) } }
