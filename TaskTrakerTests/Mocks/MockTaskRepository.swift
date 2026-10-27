import Foundation
@testable import TaskTracker

final class MockTaskRepository: TaskRepositoryProtocol {
    var stored: [TaskItem] = []
    func allTasks() -> [TaskItem] { stored }
    func add(_ task: TaskItem) { stored.append(task) }
    func complete(title: String) -> Bool {
        guard let i = stored.firstIndex(where: { $0.title == title }) else { return false }
        stored[i].markDone()
        return true
    }
    func removeCompleted() -> Int {
        let before = stored.count
        stored.removeAll { $0.status == .done }
        return before - stored.count
    }
}