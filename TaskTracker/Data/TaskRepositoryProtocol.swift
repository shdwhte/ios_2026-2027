import Foundation

/// Абстракція доступу до даних. Interactor знає лише про неї.
protocol TaskRepositoryProtocol {
    func allTasks() -> [TaskItem]
    func add(_ task: TaskItem)
    @discardableResult func complete(title: String) -> Bool
    @discardableResult func removeCompleted() -> Int
}