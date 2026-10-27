import SwiftUI

struct AddTaskView: View {
    @State private var title: String = ""
    @State private var priority: Priority = .medium
    @State private var hasDeadline: Bool = false
    @State private var dueDate: Date = Date()
    
    var onSave: (String, Priority, Date?) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Основна інформація")) {
                    TextField("Назва завдання", text: $title)
                    
                    Picker("Пріоритет", selection: $priority) {
                        Text("Низький").tag(Priority.low)
                        Text("Середній").tag(Priority.medium)
                        Text("Високий").tag(Priority.high)
                    }
                }
                
                Section(header: Text("Час")) {
                    Toggle("Встановити дедлайн", isOn: $hasDeadline)
                    if hasDeadline {
                        DatePicker("Дата та час", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
            }
            .navigationTitle("Нове завдання")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Скасувати", action: onCancel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Зберегти") {
                        onSave(title, priority, hasDeadline ? dueDate : nil)
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
