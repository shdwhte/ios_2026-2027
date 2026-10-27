import Foundation

protocol TaskSortStrategy {
    func sorted(_ tasks: [TaskItem]) -> [TaskItem]
}

struct SortByDateStrategy: TaskSortStrategy {
    func sorted(_ tasks: [TaskItem]) -> [TaskItem] {
        tasks.sorted { l, r in
            switch (l.dueDate, r.dueDate) {
            case let (a?, b?): return a < b
            case (_?, nil):    return true   // завд без дати — в кінець
            default:           return false
            }
        }
    }
}

struct SortByPriorityStrategy: TaskSortStrategy {
    private func weight(_ p: Priority) -> Int {
        switch p {
        case .high: return 0
        case .medium: return 1
        case .low: return 2
        }
    }
    func sorted(_ tasks: [TaskItem]) -> [TaskItem] {
        tasks.sorted { weight($0.priority) < weight($1.priority) }
    }
}

struct SortByTitleStrategy: TaskSortStrategy {
    func sorted(_ tasks: [TaskItem]) -> [TaskItem] {
        tasks.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }
}