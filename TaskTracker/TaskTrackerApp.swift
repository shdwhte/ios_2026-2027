import SwiftUI

@main
struct TaskTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            TaskModuleBuilder().build()
        }
    }
}