import Foundation

struct TaskItem: Describable, Identifiable {
    let id: UUID
    var title: String
    var priority: Priority
    var status: TaskStatus
    var dueDate: Date?

    init(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.priority = priority
        self.status = .todo
        self.dueDate = dueDate
    }

    var formattedDate: String {
        guard let dueDate else { return "без дедлайну" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: dueDate)
    }

    var summary: String {
        "\(title) [\(priority)] — \(status), \(formattedDate)"
    }

    mutating func markDone() {
        status = .done
    }
}