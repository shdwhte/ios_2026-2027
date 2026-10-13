import Foundation

// enum: скінченний набір варіантів
enum Priority: String, CaseIterable {
    case low, medium, high
}

enum TaskStatus {
    case todo, inProgress, done
}

// protocol: набір вимог до типу
protocol Describable {
    var summary: String { get }
}

// struct: семантика значення (копіюється при присвоєнні)
struct TaskItem: Describable {
    let id: UUID                 // let: константа
    var title: String            // var: змінна
    var priority: Priority
    var status: TaskStatus
    var dueDate: Date?           // optional: дедлайну може не бути

    init(title: String, priority: Priority = .medium, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.priority = priority
        self.status = .todo
        self.dueDate = dueDate
    }

    // безпечне розгортання optional через if let та умовна конструкція
    var formattedDate: String {
        if let date = dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            return formatter.string(from: date)
        } else {
            return "немає"
        }
    }

    var summary: String {
        "[\(status)] \(title), пріоритет: \(priority.rawValue), дедлайн: \(formattedDate)"
    }

    mutating func markDone() {
        status = .done
    }
}

// class: семантика посилання (дві змінні можуть вказувати на один об'єкт)
final class TaskList: Describable {
    let name: String
    private(set) var tasks: [TaskItem] = []   // колекція

    init(name: String) {
        self.name = name
    }

    var summary: String {
        "\(name): \(tasks.count) завдань"
    }

    func add(_ task: TaskItem) {
        tasks.append(task)
    }

    func tasks(with status: TaskStatus) -> [TaskItem] {
        tasks.filter { $0.status == status }
    }

    func complete(title: String) -> Bool {
        // безпечне розгортання optional через guard let
        guard let index = tasks.firstIndex(where: { $0.title == title }) else {
            return false
        }
        tasks[index].markDone()
        return true
    }

    func nearestDeadline() -> Date? {
        tasks.compactMap { $0.dueDate }.min()
    }
    
    // обробка елементів колекції: видалення за умовою
    func removeCompleted() -> Int {
        let initialCount = tasks.count
        tasks.removeAll(where: { $0.status == .done })
        return initialCount - tasks.count
    }
}
