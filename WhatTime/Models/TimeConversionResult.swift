import Foundation

struct TimeConversionResult: Identifiable {
    let id: String  // mirrors entry.id
    let entry: TimeZoneEntry
    let formattedTime: String  // e.g. "8:00 PM"
    let dayOffset: Int         // -1, 0, or +1 relative to source date
    let isSource: Bool
    let isDestination: Bool
}
