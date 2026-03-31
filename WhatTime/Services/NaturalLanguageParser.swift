import Foundation

struct ParsedQuery {
    let hour: Int
    let minute: Int
    let sourceZone: TimeZone
    let destinationZone: TimeZone? // nil = show all presets
}

enum NaturalLanguageParser {
    // MARK: - Public

    static func parse(_ input: String) -> ParsedQuery? {
        let text = input.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return nil }

        // "now" → current time in current timezone
        if text.lowercased() == "now" {
            let components = Calendar.current.dateComponents(in: .current, from: Date())
            guard let hour = components.hour, let minute = components.minute else { return nil }
            return ParsedQuery(hour: hour, minute: minute, sourceZone: .current, destinationZone: nil)
        }

        // Strict patterns first (require "time" suffix)
        if let result = parseConversion(text) { return result }
        if let result = parseDisplay(text) { return result }

        // Loose patterns: "10 guam to manila", "11 ph"
        if let result = parseLooseConversion(text) { return result }
        if let result = parseLooseDisplay(text) { return result }

        // Current-timezone fallback: "1130", "10am", "10"
        if let result = parseCurrentZoneCompact(text) { return result }
        if let result = parseCurrentZoneStandard(text) { return result }

        // Zone-only: "canada", "australia", "guam" → current time in that zone
        return parseZoneOnly(text)
    }

    // MARK: - Patterns

    private static func parseConversion(_ text: String) -> ParsedQuery? {
        // Matches: "(hour)[:min][am/pm] (zone) time to (zone) time"
        let pattern = #"(\d{1,2})(?::(\d{2}))?\s*(am?|pm?)?\s+(\w+(?:\s+\w+)?)\s+time\s+to\s+(\w+(?:\s+\w+)?)\s+time"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        guard
            let (hour, minute) = extractTime(from: match, in: nsText, hourGroup: 1, minuteGroup: 2, ampmGroup: 3),
            let sourceZone = extractZone(from: match, in: nsText, group: 4),
            let destZone = extractZone(from: match, in: nsText, group: 5) else {
            return nil
        }

        return ParsedQuery(hour: hour, minute: minute, sourceZone: sourceZone, destinationZone: destZone)
    }

    private static func parseDisplay(_ text: String) -> ParsedQuery? {
        // Matches: "(hour)[:min][am/pm] (zone) time"
        let pattern = #"(\d{1,2})(?::(\d{2}))?\s*(am?|pm?)?\s+(\w+(?:\s+\w+)?)\s+time"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        guard
            let (hour, minute) = extractTime(from: match, in: nsText, hourGroup: 1, minuteGroup: 2, ampmGroup: 3),
            let sourceZone = extractZone(from: match, in: nsText, group: 4) else {
            return nil
        }

        return ParsedQuery(hour: hour, minute: minute, sourceZone: sourceZone, destinationZone: nil)
    }

    private static func parseLooseConversion(_ text: String) -> ParsedQuery? {
        // Matches: "(hour)[:min][am/pm] (zone) [time] to (zone) [time]"
        let pattern = #"(\d{1,2})(?::(\d{2}))?\s*(am?|pm?)?\s+(\w+(?:\s+\w+)?)\s+to\s+(\w+(?:\s+\w+)?)(?:\s+time)?"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        guard
            let (hour, minute) = extractTime(from: match, in: nsText, hourGroup: 1, minuteGroup: 2, ampmGroup: 3),
            let sourceZone = extractZone(from: match, in: nsText, group: 4),
            let destZone = extractZone(from: match, in: nsText, group: 5) else {
            return nil
        }

        return ParsedQuery(hour: hour, minute: minute, sourceZone: sourceZone, destinationZone: destZone)
    }

    private static func parseLooseDisplay(_ text: String) -> ParsedQuery? {
        // Matches: "(hour)[:min][am/pm] (zone)" — no "time" required
        let pattern = #"(\d{1,2})(?::(\d{2}))?\s*(am?|pm?)?\s+(\w+(?:\s+\w+)?)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        guard
            let (hour, minute) = extractTime(from: match, in: nsText, hourGroup: 1, minuteGroup: 2, ampmGroup: 3),
            let sourceZone = extractZone(from: match, in: nsText, group: 4) else {
            return nil
        }

        return ParsedQuery(hour: hour, minute: minute, sourceZone: sourceZone, destinationZone: nil)
    }

    private static func parseZoneOnly(_ text: String) -> ParsedQuery? {
        guard let identifier = TimeZoneData.nameMap[text.lowercased()],
              let zone = TimeZone(identifier: identifier) else { return nil }
        let components = Calendar.current.dateComponents(in: zone, from: Date())
        guard let hour = components.hour, let minute = components.minute else { return nil }
        return ParsedQuery(hour: hour, minute: minute, sourceZone: zone, destinationZone: nil)
    }

    private static func parseCurrentZoneCompact(_ text: String) -> ParsedQuery? {
        // Matches 3–4 digit compact time at end of input: "1130", "930", "1130pm"
        // 4-digit → HHMM (1130 = 11:30), 3-digit → HMM (930 = 9:30)
        let pattern = #"(\d{3,4})\s*(am?|pm?)?\s*$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        let digitsRange = match.range(at: 1)
        guard digitsRange.location != NSNotFound else { return nil }
        let digits = nsText.substring(with: digitsRange)

        let rawHour: Int
        let rawMinute: Int
        if digits.count == 4 {
            guard let h = Int(digits.prefix(2)), let m = Int(digits.suffix(2)) else { return nil }
            rawHour = h
            rawMinute = m
        } else {
            guard let h = Int(digits.prefix(1)), let m = Int(digits.suffix(2)) else { return nil }
            rawHour = h
            rawMinute = m
        }

        let ampmRange = match.range(at: 2)
        let ampm = ampmRange.location != NSNotFound ? nsText.substring(with: ampmRange).lowercased() : nil

        var hour = rawHour
        if let ampm {
            if ampm.hasPrefix("p") && hour < 12 { hour += 12 }
            else if ampm.hasPrefix("a") && hour == 12 { hour = 0 }
        }

        guard (0 ... 23).contains(hour), (0 ... 59).contains(rawMinute) else { return nil }
        return ParsedQuery(hour: hour, minute: rawMinute, sourceZone: .current, destinationZone: nil)
    }

    private static func parseCurrentZoneStandard(_ text: String) -> ParsedQuery? {
        // Matches time-only at end of input: "10am", "8:30pm", "10"
        // The $ anchor prevents matching when a zone name follows (e.g. "10 guam" won't reach here).
        let pattern = #"(\d{1,2})(?::(\d{2}))?\s*(am?|pm?)?\s*$"#
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let nsText = text as NSString
        guard let match = regex?.firstMatch(in: text, range: NSRange(location: 0, length: nsText.length)) else {
            return nil
        }

        guard let (hour, minute) = extractTime(from: match, in: nsText, hourGroup: 1, minuteGroup: 2, ampmGroup: 3) else {
            return nil
        }

        return ParsedQuery(hour: hour, minute: minute, sourceZone: .current, destinationZone: nil)
    }

    // MARK: - Helpers

    private static func extractTime(
        from match: NSTextCheckingResult,
        in text: NSString,
        hourGroup: Int,
        minuteGroup: Int,
        ampmGroup: Int
    ) -> (Int, Int)? {
        let hourRange = match.range(at: hourGroup)
        guard hourRange.location != NSNotFound,
              let rawHour = Int(text.substring(with: hourRange)) else {
            return nil
        }

        let rawMinute: Int
        let minuteRange = match.range(at: minuteGroup)
        if minuteRange.location != NSNotFound {
            rawMinute = Int(text.substring(with: minuteRange)) ?? 0
        } else {
            rawMinute = 0
        }

        let ampmRange = match.range(at: ampmGroup)
        let ampm = ampmRange.location != NSNotFound
            ? text.substring(with: ampmRange).lowercased()
            : nil

        var hour = rawHour
        if let ampm {
            if ampm.hasPrefix("p") && hour < 12 {
                hour += 12
            } else if ampm.hasPrefix("a") && hour == 12 {
                hour = 0
            }
        }
        // No am/pm: hour is used as-is (24h). 1–12 = am, 13–23 = pm.

        guard (0 ... 23).contains(hour), (0 ... 59).contains(rawMinute) else { return nil }
        return (hour, rawMinute)
    }

    private static func extractZone(
        from match: NSTextCheckingResult,
        in text: NSString,
        group: Int
    ) -> TimeZone? {
        let range = match.range(at: group)
        guard range.location != NSNotFound else { return nil }
        let name = text.substring(with: range).lowercased()

        guard let identifier = TimeZoneData.nameMap[name] else { return nil }
        return TimeZone(identifier: identifier)
    }
}
