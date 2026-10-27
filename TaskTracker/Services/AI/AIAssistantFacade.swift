import Foundation

final class AIAssistantFacade: AIAssistantProtocol {
    private let deadlineExtractor: DeadlineExtracting
    private let priorityDetector: PriorityDetecting

    init(deadlineExtractor: DeadlineExtracting = DeadlineExtractor(),
         priorityDetector: PriorityDetecting = PriorityDetector()) {
        self.deadlineExtractor = deadlineExtractor
        self.priorityDetector = priorityDetector
    }

    func processVoiceInput(_ text: String) -> ParsedTask? {
        let deadline = deadlineExtractor.extract(from: text)
        let priority = priorityDetector.detect(in: text)

        var title = text
        let ranges = [deadline?.range, priority.range]
            .compactMap { $0 }
            .sorted { $0.lowerBound > $1.lowerBound }
        for r in ranges { title.removeSubrange(r) }

        title = title.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        title = title.trimmingCharacters(in: CharacterSet.punctuationCharacters.union(.whitespaces))

        guard !title.isEmpty else { return nil }
        return ParsedTask(title: title, priority: priority.priority, dueDate: deadline?.date)
    }
}