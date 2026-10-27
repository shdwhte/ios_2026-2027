import Foundation

struct TaskRowViewModel: Identifiable, Equatable {
    let id: UUID
    let title: String
    let dueText: String
    let priorityText: String
    let isDone: Bool
}

extension Priority {
    var displayName: String {
        switch self {
        case .low: return "Низький"
        case .medium: return "Середній"
        case .high: return "Високий"
        }
    }
}