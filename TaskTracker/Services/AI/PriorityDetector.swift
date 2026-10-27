import Foundation

protocol PriorityDetecting {
    func detect(in text: String) -> (priority: Priority, range: Range<String.Index>?)
}

struct PriorityDetector: PriorityDetecting {
    private let high = ["терміново", "важливо", "urgent"]
    private let low = ["не горить", "пізніше", "колись"]

    func detect(in text: String) -> (priority: Priority, range: Range<String.Index>?) {
        for word in high {
            if let r = text.range(of: word, options: .caseInsensitive) { return (.high, r) }
        }
        for word in low {
            if let r = text.range(of: word, options: .caseInsensitive) { return (.low, r) }
        }
        return (.medium, nil)
    }
}