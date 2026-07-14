import SwiftUI
struct ArticleRow: View {
    let article: Article
    var body: some View { VStack(alignment: .leading, spacing: 6) { Text(article.title).font(.headline).lineLimit(2); Text(article.urlString).font(.caption).foregroundStyle(.secondary).lineLimit(1); HStack { Label(article.totalReadingTime.readingDisplay, systemImage: "clock"); Spacer(); if let date = article.lastReadDate { Text(date, style: .relative).foregroundStyle(.secondary) } }.font(.caption) }.accessibilityElement(children: .combine).accessibilityLabel("\(article.title), read for \(article.totalReadingTime.readingDisplay)") }
}
