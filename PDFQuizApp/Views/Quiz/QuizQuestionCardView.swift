import SwiftUI

struct QuizQuestionCardView: View {
    let question: CDQuestion
    let selectedLabels: Set<String>
    let showResult: Bool
    let onToggle: (String) -> Void

    private var correctLabels: [String] {
        (question.correctAnswer as? [String]) ?? []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(question.type.flatMap { QuestionType(rawValue: $0)?.displayName } ?? "题目")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appPrimary.opacity(0.1))
                    .foregroundColor(.appPrimary)
                    .cornerRadius(4)

                Spacer()

                if question.detectionConfidence < 0.7 {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.appWarning)
                        .font(.caption)
                }
            }

            Text(question.questionText ?? "")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            if let options = question.options as? Set<CDOption> {
                let sorted = options.sorted { ($0.orderIndex) < ($1.orderIndex) }
                ForEach(sorted, id: \.id) { option in
                    QuizOptionButton(
                        label: option.label ?? "",
                        text: option.text ?? "",
                        isSelected: selectedLabels.contains(option.label ?? ""),
                        isCorrect: showResult ? correctLabels.contains(option.label ?? "") : nil,
                        showResult: showResult,
                        onTap: { onToggle(option.label ?? "") }
                    )
                }
            }
        }
        .cardStyle()
    }
}
