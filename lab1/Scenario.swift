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