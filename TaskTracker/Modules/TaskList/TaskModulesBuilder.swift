import SwiftUI

/// BUILDER: місце, де ств й зв'язую всі комп VIPER-мод.
struct TaskModuleBuilder {
    private let repository: TaskRepositoryProtocol
    private let assistant: AIAssistantProtocol

    init(repository: TaskRepositoryProtocol = InMemoryTaskRepository.demo(),
         assistant: AIAssistantProtocol = AIAssistantFacade()) {
        self.repository = repository
        self.assistant = assistant
    }

    func makePresenter() -> TaskListPresenter {
        let interactor = TaskListInteractor(repository: repository, assistant: assistant)
        let presenter = TaskListPresenter(interactor: interactor, router: TaskListRouter())
        interactor.output = presenter
        return presenter
    }

    func build() -> TaskListView {
        TaskListView(presenter: makePresenter())
    }
}