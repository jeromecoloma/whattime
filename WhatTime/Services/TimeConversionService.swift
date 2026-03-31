import Foundation

enum TimeConversionService {
    // MARK: - Public

    static func convert(query: ParsedQuery, presets: [TimeZoneEntry]) -> [TimeConversionResult] {
        guard let sourceDate = buildSourceDate(hour: query.hour, minute: query.minute, in: query.sourceZone) else {
            return []
        }

        var sourceCalendar = Calendar(identifier: .gregorian)
        sourceCalendar.timeZone = query.sourceZone
        let sourceDay = sourceCalendar.component(.day, from: sourceDate)

        let targetEntries = resolveTargetEntries(query: query, presets: presets)

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        return targetEntries.map { entry in
            formatter.timeZone = entry.timeZone
            let formattedTime = formatter.string(from: sourceDate)

            var destCalendar = Calendar(identifier: .gregorian)
            destCalendar.timeZone = entry.timeZone
            let destDay = destCalendar.component(.day, from: sourceDate)
            let dayOffset = normalizeDayOffset(destDay - sourceDay)

            let isSource = entry.timeZone.identifier == query.sourceZone.identifier
            let isDestination = query.destinationZone.map { $0.identifier == entry.timeZone.identifier } ?? false

            return TimeConversionResult(
                id: entry.id,
                entry: entry,
                formattedTime: formattedTime,
                dayOffset: dayOffset,
                isSource: isSource,
                isDestination: isDestination
            )
        }
    }

    // MARK: - Private

    private static func buildSourceDate(hour: Int, minute: Int, in zone: TimeZone) -> Date? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone

        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        components.second = 0
        components.timeZone = zone

        return calendar.date(from: components)
    }

    private static func resolveTargetEntries(query: ParsedQuery, presets: [TimeZoneEntry]) -> [TimeZoneEntry] {
        guard let destZone = query.destinationZone else {
            return presets
        }

        // If the destination is already in the presets, reuse that entry (with its name/flag)
        if let existing = presets.first(where: { $0.timeZone.identifier == destZone.identifier }) {
            return [existing]
        }

        // Otherwise build a fallback entry from the timezone itself
        let name = destZone.localizedName(for: .standard, locale: .current)
            ?? destZone.identifier
        return [TimeZoneEntry(id: destZone.identifier, name: name, flag: "🌐")]
    }

    private static func normalizeDayOffset(_ raw: Int) -> Int {
        // Handle month boundary wrap-around (e.g. day 31 vs day 1 → +1)
        if raw > 20 { return raw - 31 }
        if raw < -20 { return raw + 31 }
        return raw
    }
}
