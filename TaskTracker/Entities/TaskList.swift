import Foundation

final class TaskList: Describable {
    let name: String
    private(set) var tasks: [TaskItem] = []

    init(name: String) {
        self.name = name
    }

    var summary: String {
        "Список «\(name)»: завдань — \(tasks.count)"
    }

    func add(_ task: TaskItem) {
        tasks.append(task)
    }

    func tasks(with status: TaskStatus) -> [TaskItem] {
        tasks.filter { $0.status == status }
    }

    @discardableResult
    func complete(title: String) -> Bool {
        guard let index = tasks.firstIndex(where: { $0.title == title && $0.status != .done }) else {
            return false
        }
        tasks[index].markDone()
        return true
    }

    func nearestDeadline() -> Date? {
        tasks
            .filter { $0.status != .done }
            .compactMap { $0.dueDate }
            .min()
    }

    @discardableResult
    func removeCompleted() -> Int {
        let before = tasks.count
        tasks.removeAll { $0.status == .done }
        return before - tasks.count
    }
}