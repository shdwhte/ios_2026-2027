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

    var summary: String {
        "[\(status)] \(title), пріоритет: \(priority.rawValue)"
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
}

import Foundation

/// Завершений сценарій: створення, додавання, зміна стану, фільтрація.
func runScenario() -> [String] {
    var log: [String] = []

    let list = TaskList(name: "Навчання")
    let tomorrow = Date().addingTimeInterval(86_400)

    // 1. створення сутностей і додавання до колекції
    list.add(TaskItem(title: "Зробити практичну", priority: .high, dueDate: tomorrow))
    list.add(TaskItem(title: "Прочитати лекцію"))
    list.add(TaskItem(title: "Здати лабу", priority: .low))
    log.append(list.summary)

    // 2. зміна стану + умовна конструкція
    if list.complete(title: "Зробити практичну") {
        log.append("Виконано: Зробити практичну")
    } else {
        log.append("Не знайдено")
    }
    if !list.complete(title: "Неіснуюче завдання") {
        log.append("Завдання 'Неіснуюче завдання' не знайдено (guard let спрацював)")
    }

    // 3. фільтрація і обробка елементів колекції
    log.append("Невиконані завдання:")
    for task in list.tasks(with: .todo) {
        log.append(" - " + task.summary)
    }

    // 4. optional: if let, optional chaining, ??
    if let deadline = list.nearestDeadline() {
        log.append("Найближчий дедлайн: \(deadline)")
    } else {
        log.append("Дедлайнів немає")
    }
    let firstTitle = list.tasks.first?.title ?? "список порожній"
    log.append("Перше завдання: \(firstTitle)")

    // 5. семантика значення (struct) проти семантики посилання (class)
    let original = TaskItem(title: "Оригінал")
    var copy = original
    copy.title = "Копія"
    log.append("struct: original = \(original.title), copy = \(copy.title)")

    let sameList = list
    sameList.add(TaskItem(title: "Додано через іншу змінну"))
    log.append("class: list.tasks.count = \(list.tasks.count) (sameList вказує на той самий об'єкт)")

    return log
}

runScenario().forEach { print($0) }