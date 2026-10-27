import SwiftUI

struct TaskListRouter: TaskListRouterProtocol {
    func makeAddTaskView(onSave: @escaping (String, Priority, Date?) -> Void,
                         onCancel: @escaping () -> Void) -> AnyView {
        AnyView(AddTaskView(onSave: onSave, onCancel: onCancel))
    }
}