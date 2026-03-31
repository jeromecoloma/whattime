import SwiftUI

struct TimeResultRow: View {
    let result: TimeConversionResult

    var body: some View {
        HStack(spacing: 12) {
            Text(result.entry.flag)
                .font(.title2)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(result.entry.name)
                    .font(.headline)
                if let label = roleLabel {
                    Text(label)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(result.formattedTime)
                    .font(.system(size: 20, weight: .semibold, design: .monospaced))

                if result.dayOffset != 0 {
                    Text(dayOffsetLabel)
                        .font(.caption)
                        .foregroundStyle(result.dayOffset > 0 ? Color.blue : Color.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            (result.dayOffset > 0 ? Color.blue : Color.orange).opacity(0.12),
                            in: Capsule()
                        )
                }
            }
        }
        .padding(.vertical, 6)
        .listRowBackground(
            result.isSource || result.isDestination
                ? Color.accentColor.opacity(0.07)
                : Color.clear
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
    }

    // MARK: - Private

    private var roleLabel: String? {
        if result.isSource { return "source" }
        if result.isDestination { return "destination" }
        return nil
    }

    private var dayOffsetLabel: String {
        result.dayOffset > 0 ? "+\(result.dayOffset)d" : "\(result.dayOffset)d"
    }

    private var accessibilityDescription: String {
        var parts = [result.entry.name, result.formattedTime]
        if result.dayOffset != 0 {
            parts.append(result.dayOffset > 0 ? "next day" : "previous day")
        }
        if let label = roleLabel {
            parts.append("(\(label))")
        }
        return parts.joined(separator: ", ")
    }
}
