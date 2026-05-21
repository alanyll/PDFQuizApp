import SwiftUI

struct WrongAnswerRowView: View {
    @ObservedObject var wrongAnswer: CDWrongAnswer

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(wrongAnswer.question?.questionText ?? "未知题目")
                    .font(.subheadline)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Label("错\(wrongAnswer.wrongCountTotal)次", systemImage: "xmark.circle")
                        .font(.caption2)

                    if let status = wrongAnswer.masteryStatus.flatMap(MasteryStatus.init(rawValue:)) {
                        Text(status.displayName)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(masteryColor(for: status).opacity(0.15))
                            .foregroundColor(masteryColor(for: status))
                            .cornerRadius(4)
                    }
                }
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private func masteryColor(for status: MasteryStatus) -> Color {
        switch status {
        case .new: return .appDanger
        case .learning: return .appWarning
        case .reviewing: return .appPrimary
        case .mastered: return .appSuccess
        }
    }
}
