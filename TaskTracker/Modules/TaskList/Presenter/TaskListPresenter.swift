import SwiftUI

final class TaskListPresenter: ObservableObject,
                               TaskListPresenterProtocol,
                               TaskListInteractorOutputProtocol {
    // sтан для View
    @Published private(set) var rows: [TaskRowViewModel] = []
    @Published var selectedSort: SortOption = .date
    @Published var isAddSheetPresented = false
    @Published var errorMessage: String?
    @Published var infoMessage: String?

    private let interactor: TaskListInteractorProtocol
    private let router: TaskListRouterProtocol

    init(interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: View => Presenter
    func viewDidAppear() { interactor.loadTasks() }

    func didSelectSort(_ option: SortOption) {
        selectedSort = option
        interactor.setSortStrategy(option.strategy)
    }

    func didTapAdd() { isAddSheetPresented = true }

    func didSubmitNewTask(title: String, priority: Priority, dueDate: Date?) {
        isAddSheetPresented = false
        interactor.addTask(title: title, priority: priority, dueDate: dueDate)
    }

    func didSubmitVoiceInput(_ text: String) { interactor.addTask(fromVoiceInput: text) }
    func didTapComplete(_ row: TaskRowViewModel) { interactor.completeTask(title: row.title) }
    func didTapRemoveCompleted() { interactor.removeCompleted() }

    func makeAddTaskView() -> AnyView {
        router.makeAddTaskView(
            onSave: { [weak self] title, priority, date in
                self?.didSubmitNewTask(title: title, priority: priority, dueDate: date)
            },
            onCancel: { [weak self] in self?.isAddSheetPresented = false }
        )
    }

    // MARK: Interactor => Presenter
    func didLoad(tasks: [TaskItem]) {
        rows = tasks.map {
            TaskRowViewModel(id: $0.id,
                             title: $0.title,
                             dueText: $0.formattedDate,
                             priorityText: $0.priority.displayName,
                             isDone: $0.status == .done)
        }
    }

    func didFail(message: String) { errorMessage = message }

    func didRemoveCompleted(count: Int) {
        infoMessage = count > 0 ? "Видалено завдань: \(count)" : "Немає виконаних завдань"
    }
}