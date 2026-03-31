import Foundation

struct TimeZoneEntry: Identifiable, Hashable {
    let id: String  // IANA timezone identifier, e.g. "Pacific/Palau"
    let name: String
    let flag: String

    var timeZone: TimeZone {
        TimeZone(identifier: id) ?? .current
    }
}
