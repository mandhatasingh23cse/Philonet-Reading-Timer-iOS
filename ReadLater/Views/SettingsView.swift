import SwiftUI
struct SettingsView: View { var body: some View { Form { Section("About") { LabeledContent("Storage", value: "On-device SwiftData"); LabeledContent("Minimum iOS", value: "17.0") } }.navigationTitle("Settings") } }
