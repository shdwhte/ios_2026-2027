import SwiftUI

struct TaskListView: View {
    @StateObject private var presenter: TaskListPresenter
    @State private var voiceText = ""

    // autoclosure: Presenter ств 1 раз, а не при кожн оновленні батьк View
    init(presenter: @autoclosure @escaping () -> TaskListPresenter) {
        _presenter = StateObject(wrappedValue: presenter())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                HStack {
                    TextField("Напр.: Купити молоко завтра терміново", text: $voiceText)
                        .textFieldStyle(.roundedBorder)
                    Button("ШІ") {
                        presenter.didSubmitVoiceInput(voiceText)
                        voiceText = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(voiceText.isEmpty)
                }
                .padding(.horizontal)

                Picker("Сортування", selection: Binding(
                    get: { presenter.selectedSort },
                    set: { presenter.didSelectSort($0) })
                ) {
                    ForEach(SortOption.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                List(presenter.rows) { row in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(row.title)
                                .strikethrough(row.isDone)
                            Text("\(row.priorityText) · \(row.dueText)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if !row.isDone {
                            Button { presenter.didTapComplete(row) } label: {
                                Image(systemName: "checkmark.circle")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
            }
            .navigationTitle("TaskTracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { presenter.didTapAdd() } label: { Image(systemName: "plus") }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button("Очистити виконані") { presenter.didTapRemoveCompleted() }
                }
            }
            .sheet(isPresented: $presenter.isAddSheetPresented) {
                presenter.makeAddTaskView()
            }
            .alert("Помилка", isPresented: Binding(
                get: { presenter.errorMessage != nil },
                set: { if !$0 { presenter.errorMessage = nil } })
            ) {
                Button("OK", role: .cancel) {}
            } message: { Text(presenter.errorMessage ?? "") }
            .alert("Готово", isPresented: Binding(
                get: { presenter.infoMessage != nil },
                set: { if !$0 { presenter.infoMessage = nil } })
            ) {
                Button("OK", role: .cancel) {}
            } message: { Text(presenter.infoMessage ?? "") }
            .onAppear { presenter.viewDidAppear() }
        }
    }
}