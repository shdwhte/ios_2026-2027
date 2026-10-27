import Foundation

struct ParsedTask: Equatable {
    let title: String
    let priority: Priority
    let dueDate: Date?
}