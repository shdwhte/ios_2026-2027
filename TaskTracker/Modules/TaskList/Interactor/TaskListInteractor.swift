import Foundation

final class TaskListInteractor: TaskListInteractorProtocol {
    weak var output: TaskListInteractorOutputProtocol?   // weak, щоб не було циклу з Presenter

    private let repository: TaskRepositoryProtocol
    private let assistant: AIAssistantProtocol
    private var sortStrategy: TaskSortStrategy

    init(repository: TaskRepositoryProtocol,
         assistant: AIAssistantProtocol,
         sortStrategy: TaskSortStrategy = SortByDateStrategy()) {
        self.repository = repository
        self.assistant = assistant
        self.sortStrategy = sortStrategy
    }

    func loadTasks() {
        output?.didLoad(tasks: sortStrategy.sorted(repository.allTasks()))
    }

    func setSortStrategy(_ strategy: TaskSortStrategy) {
        sortStrategy = strategy
        loadTasks()
    }

    func addTask(title: String, priority: Priority, dueDate: Date?) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            output?.didFail(message: "Назва завдання не може бути порожньою")
            return
        }
        repository.add(TaskItem(title: trimmed, priority: priority, dueDate: dueDate))
        loadTasks()
    }

    func addTask(fromVoiceInput text: String) {
        guard let parsed = assistant.processVoiceInput(text) else {
            output?.didFail(message: "Не вдалося розпізнати завдання")
            return
        }
        addTask(title: parsed.title, priority: parsed.priority, dueDate: parsed.dueDate)
    }

    func completeTask(title: String) {
        if !repository.complete(title: title) {
            output?.didFail(message: "Завдання «\(title)» не знайдено")
        }
        loadTasks()
    }

    func removeCompleted() {
        let count = repository.removeCompleted()
        output?.didRemoveCompleted(count: count)
        loadTasks()
    }
}