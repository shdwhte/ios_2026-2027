import SwiftUI

// MARK: Interactor
protocol TaskListInteractorProtocol: AnyObject {
    var output: TaskListInteractorOutputProtocol? { get set }
    func loadTasks()
    func setSortStrategy(_ strategy: TaskSortStrategy)
    func addTask(title: String, priority: Priority, dueDate: Date?)
    func addTask(fromVoiceInput text: String)
    func completeTask(title: String)
    func removeCompleted()
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didLoad(tasks: [TaskItem])
    func didFail(message: String)
    func didRemoveCompleted(count: Int)
}

// MARK: Presenter (команди від View)
protocol TaskListPresenterProtocol: AnyObject {
    func viewDidAppear()
    func didSelectSort(_ option: SortOption)
    func didTapAdd()
    func didSubmitNewTask(title: String, priority: Priority, dueDate: Date?)
    func didSubmitVoiceInput(_ text: String)
    func didTapComplete(_ row: TaskRowViewModel)
    func didTapRemoveCompleted()
}

// MARK: Router
protocol TaskListRouterProtocol {
    func makeAddTaskView(onSave: @escaping (String, Priority, Date?) -> Void,
                         onCancel: @escaping () -> Void) -> AnyView
}