import SwiftUI

struct WrongAnswerDetailView: View {
    @ObservedObject var wrongAnswer: CDWrongAnswer
    @State private var showRetry = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Question
                VStack(alignment: .leading, spacing: 12) {
                    Text("题目")
                        .font(.headline)

                    Text(wrongAnswer.question?.questionText ?? "未知题目")
                        .font(.body)

                    if let options = wrongAnswer.question?.options as? Set<CDOption> {
                        let sorted = options.sorted { ($0.orderIndex) < ($1.orderIndex) }
                        ForEach(sorted, id: \.id) { option in
                            HStack {
                                Text("\(option.label ?? "").")
                                    .fontWeight(.medium)
                                Text(option.text ?? "")
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(6)
                        }
                    }
                }
                .cardStyle()

                // Answer info
                VStack(alignment: .leading, spacing: 8) {
                    Text("错题信息")
                        .font(.headline)

                    InfoRow(label: "错误次数", value: "\(wrongAnswer.wrongCountTotal)")
                    InfoRow(label: "掌握状态", value: wrongAnswer.masteryStatus.flatMap(MasteryStatus.init(rawValue:))?.displayName ?? "未知")
                    if let nextReview = wrongAnswer.nextReviewDate {
                        InfoRow(label: "下次复习", value: nextReview.formatted(date: .numeric, time: .omitted))
                    }
                }
                .cardStyle()

                Button(action: { showRetry = true }) {
                    Label("重新练习", systemImage: "arrow.clockwise")
                }
                .primaryButtonStyle()
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("错题详情")
        .sheet(isPresented: $showRetry) {
            WrongAnswerReviewView(wrongAnswers: [wrongAnswer])
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
