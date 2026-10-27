import Foundation

protocol AIAssistantProtocol {
    func processVoiceInput(_ text: String) -> ParsedTask?
}