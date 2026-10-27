import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    @State private var voiceInput: String = ""
    @State private var showVoicePrompt = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                
                if presenter.rows.isEmpty {
                    ContentUnavailableView("Немає завдань", systemImage: "tray", description: Text("Додайте нове завдання або скористайтеся ШІ-асистентом"))
                } else {
                    List {
                        ForEach(presenter.rows) { row in
                            TaskRowView(row: row) {
                                presenter.didTapComplete(row)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Мої завдання")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Сортування", selection: $presenter.selectedSort) {
                            Text("За датою").tag(SortOption.date)
                            Text("За пріоритетом").tag(SortOption.priority)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .onChange(of: presenter.selectedSort) { oldValue, newValue in
                        presenter.didSelectSort(newValue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { presenter.didTapRemoveCompleted() }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: { showVoicePrompt = true }) {
                            HStack {
                                Image(systemName: "waveform")
                                Text("ШІ-Асистент")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.purple.opacity(0.1))
                            .foregroundColor(.purple)
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                        
                        Button(action: { presenter.didTapAdd() }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $presenter.isAddSheetPresented) {
                presenter.makeAddTaskView()
            }
            .alert("Голосовий ввід", isPresented: $showVoicePrompt) {
                TextField("Надиктуйте завдання...", text: $voiceInput)
                Button("Скасувати", role: .cancel) { voiceInput = "" }
                Button("Відправити") {
                    presenter.didSubmitVoiceInput(voiceInput)
                    voiceInput = ""
                }
            } message: {
                Text("Наприклад: Написати звіт на завтра, високий пріоритет")
            }
            .alert("Інформація", isPresented: Binding<Bool>(
                get: { presenter.infoMessage != nil },
                set: { _ in presenter.infoMessage = nil }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(presenter.infoMessage ?? "")
            }
        }
        .onAppear {
            presenter.viewDidAppear()
        }
    }
}

struct TaskRowView: View {
    let row: TaskRowViewModel
    let onComplete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onComplete) {
                Image(systemName: row.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(row.isDone ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .strikethrough(row.isDone)
                    .foregroundColor(row.isDone ? .gray : .primary)
                    .font(.headline)
                
                if row.dueText != "немає" {
                    HStack {
                        Image(systemName: "calendar")
                        Text(row.dueText)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(row.priorityText)
                .font(.caption2.bold())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(priorityColor(row.priorityText).opacity(0.2))
                .foregroundColor(priorityColor(row.priorityText))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
    
    private func priorityColor(_ text: String) -> Color {
        switch text.lowercased() {
        case "високий": return .red
        case "середній": return .orange
        case "низький": return .green
        default: return .blue
        }
    }
}
