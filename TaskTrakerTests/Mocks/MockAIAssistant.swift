import Foundation
@testable import TaskTracker

struct MockAIAssistant: AIAssistantProtocol {
    var result: ParsedTask?
    func processVoiceInput(_ text: String) -> ParsedTask? { result }
}