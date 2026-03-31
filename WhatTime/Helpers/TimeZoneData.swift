import Foundation

enum TimeZoneData {
    static let presets: [TimeZoneEntry] = [
        TimeZoneEntry(id: "Australia/Adelaide", name: "Adelaide", flag: "🇦🇺"),
        TimeZoneEntry(id: "Asia/Manila", name: "Manila", flag: "🇵🇭"),
        TimeZoneEntry(id: "Pacific/Palau", name: "Palau", flag: "🇵🇼"),
        TimeZoneEntry(id: "Pacific/Guam", name: "Guam", flag: "🇬🇺"),
    ]

    // Maps common city/country names (lowercased) → IANA timezone identifier
    static let nameMap: [String: String] = [
        // Preset zones
        "palau": "Pacific/Palau",
        "guam": "Pacific/Guam",
        "manila": "Asia/Manila",
        "philippines": "Asia/Manila",
        "ph": "Asia/Manila",
        "adelaide": "Australia/Adelaide",

        // Extended Australia
        "australia": "Australia/Sydney",
        "sydney": "Australia/Sydney",
        "melbourne": "Australia/Melbourne",
        "brisbane": "Australia/Brisbane",
        "perth": "Australia/Perth",
        "darwin": "Australia/Darwin",
        "hobart": "Australia/Hobart",
        "canberra": "Australia/Sydney",

        // Asia
        "tokyo": "Asia/Tokyo",
        "japan": "Asia/Tokyo",
        "singapore": "Asia/Singapore",
        "hongkong": "Asia/Hong_Kong",
        "hong kong": "Asia/Hong_Kong",
        "hk": "Asia/Hong_Kong",
        "seoul": "Asia/Seoul",
        "korea": "Asia/Seoul",
        "bangkok": "Asia/Bangkok",
        "thailand": "Asia/Bangkok",
        "jakarta": "Asia/Jakarta",
        "indonesia": "Asia/Jakarta",
        "kuala lumpur": "Asia/Kuala_Lumpur",
        "kl": "Asia/Kuala_Lumpur",
        "malaysia": "Asia/Kuala_Lumpur",
        "dubai": "Asia/Dubai",
        "uae": "Asia/Dubai",
        "india": "Asia/Kolkata",
        "mumbai": "Asia/Kolkata",
        "delhi": "Asia/Kolkata",
        "kolkata": "Asia/Kolkata",
        "beijing": "Asia/Shanghai",
        "shanghai": "Asia/Shanghai",
        "china": "Asia/Shanghai",

        // Europe
        "london": "Europe/London",
        "uk": "Europe/London",
        "paris": "Europe/Paris",
        "france": "Europe/Paris",
        "berlin": "Europe/Berlin",
        "germany": "Europe/Berlin",
        "amsterdam": "Europe/Amsterdam",
        "rome": "Europe/Rome",
        "italy": "Europe/Rome",
        "madrid": "Europe/Madrid",
        "spain": "Europe/Madrid",
        "moscow": "Europe/Moscow",
        "russia": "Europe/Moscow",

        // Americas
        "new york": "America/New_York",
        "newyork": "America/New_York",
        "nyc": "America/New_York",
        "eastern": "America/New_York",
        "los angeles": "America/Los_Angeles",
        "losangeles": "America/Los_Angeles",
        "la": "America/Los_Angeles",
        "pacific": "America/Los_Angeles",
        "chicago": "America/Chicago",
        "central": "America/Chicago",
        "denver": "America/Denver",
        "mountain": "America/Denver",
        "toronto": "America/Toronto",
        "canada": "America/Toronto",
        "vancouver": "America/Vancouver",
        "mexico city": "America/Mexico_City",
        "mexico": "America/Mexico_City",
        "sao paulo": "America/Sao_Paulo",
        "brazil": "America/Sao_Paulo",

        // Pacific
        "hawaii": "Pacific/Honolulu",
        "honolulu": "Pacific/Honolulu",
        "fiji": "Pacific/Fiji",
        "auckland": "Pacific/Auckland",
        "new zealand": "Pacific/Auckland",
        "nz": "Pacific/Auckland",
        "samoa": "Pacific/Apia",
        "apia": "Pacific/Apia",

        // Reference
        "utc": "UTC",
        "gmt": "GMT",
    ]
}
