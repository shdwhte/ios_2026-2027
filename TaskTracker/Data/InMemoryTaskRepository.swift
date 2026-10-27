import Foundation

final class InMemoryTaskRepository: TaskRepositoryProtocol {
    private let list: TaskList

    init(list: TaskList = TaskList(name: "Мої завдання")) {
        self.list = list
    }

    func allTasks() -> [TaskItem] { list.tasks }
    func add(_ task: TaskItem) { list.add(task) }
    func complete(title: String) -> Bool { list.complete(title: title) }
    func removeCompleted() -> Int { list.removeCompleted() }

    /// Демонстраційні дані для запуску застосунку.
    static func demo() -> InMemoryTaskRepository {
        let repo = InMemoryTaskRepository()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        repo.add(TaskItem(title: "Здати практичну 2", priority: .high, dueDate: tomorrow))
        repo.add(TaskItem(title: "Купити каву", priority: .low, dueDate: nil))
        return repo
    }
}