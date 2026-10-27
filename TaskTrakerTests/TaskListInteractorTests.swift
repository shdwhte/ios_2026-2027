import XCTest
@testable import TaskTracker

final class TaskListInteractorTests: XCTestCase {

    private final class OutputSpy: TaskListInteractorOutputProtocol {
        var loaded: [TaskItem] = []
        var errors: [String] = []
        var removed = 0
        func didLoad(tasks: [TaskItem]) { loaded = tasks }
        func didFail(message: String) { errors.append(message) }
        func didRemoveCompleted(count: Int) { removed = count }
    }

    func testAddEmptyTitleFails() {
        let spy = OutputSpy()
        let sut = TaskListInteractor(repository: MockTaskRepository(),
                                     assistant: MockAIAssistant(result: nil))
        sut.output = spy
        sut.addTask(title: "   ", priority: .low, dueDate: nil)
        XCTAssertEqual(spy.errors.count, 1)
    }

    func testVoiceInputUsesAssistantResult() {
        let repo = MockTaskRepository()
        let spy = OutputSpy()
        let parsed = ParsedTask(title: "Молоко", priority: .high, dueDate: nil)
        let sut = TaskListInteractor(repository: repo,
                                     assistant: MockAIAssistant(result: parsed))
        sut.output = spy
        sut.addTask(fromVoiceInput: "будь-що")
        XCTAssertEqual(spy.loaded.first?.title, "Молоко")
        XCTAssertEqual(spy.loaded.first?.priority, .high)
    }

    func testSortByPriorityPutsHighFirst() {
        let repo = MockTaskRepository()
        repo.stored = [TaskItem(title: "A", priority: .low, dueDate: nil),
                       TaskItem(title: "B", priority: .high, dueDate: nil)]
        let spy = OutputSpy()
        let sut = TaskListInteractor(repository: repo, assistant: MockAIAssistant(result: nil),
                                     sortStrategy: SortByPriorityStrategy())
        sut.output = spy
        sut.loadTasks()
        XCTAssertEqual(spy.loaded.map(\.title), ["B", "A"])
    }
}