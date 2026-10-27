import SwiftUI

struct AddTaskView: View {
    let onSave: (String, Priority, Date?) -> Void
    let onCancel: () -> Void

    @State private var title = ""
    @State private var priority: Priority = .medium
    @State private var hasDueDate = false
    @State private var dueDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Назва", text: $title)
                Picker("Пріоритет", selection: $priority) {
                    ForEach([Priority.low, .medium, .high], id: \.self) {
                        Text($0.displayName).tag($0)
                    }
                }
                Toggle("Є дедлайн", isOn: $hasDueDate)
                if hasDueDate {
                    DatePicker("Дедлайн", selection: $dueDate)
                }
            }
            .navigationTitle("Нове завдання")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Додати") { onSave(title, priority, hasDueDate ? dueDate : nil) }
                }
            }
        }
    }
}