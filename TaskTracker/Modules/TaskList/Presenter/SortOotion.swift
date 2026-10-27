import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case date = "За датою"
    case priority = "За пріоритетом"
    case title = "За назвою"

    var id: String { rawValue }

    var strategy: TaskSortStrategy {
        switch self {
        case .date: return SortByDateStrategy()
        case .priority: return SortByPriorityStrategy()
        case .title: return SortByTitleStrategy()
        }
    }
}