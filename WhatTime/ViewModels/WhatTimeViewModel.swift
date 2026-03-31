import Foundation
import SwiftUI

@MainActor
final class WhatTimeViewModel: ObservableObject {

    // MARK: - State

    @Published var queryText: String = ""
    @Published private(set) var results: [TimeConversionResult] = []
    @Published private(set) var parseError: String? = nil

    // MARK: - Intent

    func processQuery() {
        let text = queryText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else {
            results = []
            parseError = nil
            return
        }

        guard let query = NaturalLanguageParser.parse(text) else {
            parseError = "Couldn't understand that query.\nTry: \"8pm palau time\" or \"9am guam time to manila time\""
            results = []
            return
        }

        parseError = nil
        results = TimeConversionService.convert(query: query, presets: TimeZoneData.presets)
    }

    func clear() {
        queryText = ""
        results = []
        parseError = nil
    }
}
