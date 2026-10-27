import XCTest
@testable import TaskTracker

final class AIAssistantFacadeTests: XCTestCase {
    func testParsesTitlePriorityAndDeadline() {
        let sut = AIAssistantFacade()
        let result = sut.processVoiceInput("Купити молоко завтра терміново")
        XCTAssertEqual(result?.title, "Купити молоко")
        XCTAssertEqual(result?.priority, .high)
        XCTAssertNotNil(result?.dueDate)
    }

    func testEmptyTitleReturnsNil() {
        XCTAssertNil(AIAssistantFacade().processVoiceInput("завтра терміново"))
    }
}