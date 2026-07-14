import SwiftUI
import Observation
@Observable @MainActor final class LifecycleService { var phase: ScenePhase = .active; var isActive: Bool { phase == .active } }
