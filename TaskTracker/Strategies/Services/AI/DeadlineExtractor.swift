import Foundation

protocol DeadlineExtracting {
    func extract(from text: String) -> (date: Date, range: Range<String.Index>)?
}

struct DeadlineExtractor: DeadlineExtracting {
    private let calendar: Calendar
    private let now: () -> Date

    init(calendar: Calendar = .current, now: @escaping () -> Date = Date.init) {
        self.calendar = calendar
        self.now = now
    }

    func extract(from text: String) -> (date: Date, range: Range<String.Index>)? {
        // "післязавтра" першим, бо містить слово "завтра"
        let words: [(String, Int)] = [("післязавтра", 2), ("завтра", 1), ("сьогодні", 0)]
        for (word, offset) in words {
            if let range = text.range(of: word, options: .caseInsensitive) {
                let day = calendar.date(byAdding: .day, value: offset,
                                        to: calendar.startOfDay(for: now()))!
                let date = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: day) ?? day
                return (date, range)
            }
        }
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        let nsRange = NSRange(location: 0, length: (text as NSString).length)
        if let match = detector?.firstMatch(in: text, range: nsRange),
           let date = match.date,
           let range = Range(match.range, in: text) {
            return (date, range)
        }
        return nil
    }
}