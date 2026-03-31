import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WhatTimeViewModel

    var body: some View {
        VStack(spacing: 0) {
            searchBar
            Divider()
            resultArea
        }
        .frame(minWidth: 520, minHeight: 400)
        .navigationTitle("WhatTime")
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "clock.arrow.2.circlepath")
                .foregroundStyle(.secondary)
                .font(.system(size: 16))
                .accessibilityHidden(true)

            TextField("e.g. 8pm palau time  or  8pm palau time to guam time", text: $viewModel.queryText)
                .textFieldStyle(.plain)
                .font(.system(size: 16))
                .onSubmit { viewModel.processQuery() }
                .accessibilityLabel("Time query")
                .accessibilityHint("Type a time and location, then press Return")

            if !viewModel.queryText.isEmpty {
                Button(action: viewModel.clear) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("Clear")
                .accessibilityLabel("Clear query")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Result Area

    private var resultArea: some View {
        Group {
            if let error = viewModel.parseError {
                errorView(error)
            } else if viewModel.results.isEmpty {
                emptyState
            } else {
                resultsList
            }
        }
    }

    private var resultsList: some View {
        List(viewModel.results) { result in
            TimeResultRow(result: result)
                .listRowSeparator(.visible)
        }
        .listStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: viewModel.results.map(\.id))
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "Ask About Time",
            systemImage: "clock",
            description: Text(
                "Type a time query and press Return.\n" +
                    "Examples:\n" +
                    "  • \"8pm palau time\"\n" +
                    "  • \"9am guam time to manila time\"\n" +
                    "  • \"what is 8:30pm palau time to guam time\""
            )
        )
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 40))
                .foregroundStyle(.orange)
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
    }
}
