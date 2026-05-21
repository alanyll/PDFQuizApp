import SwiftUI

struct QuizResultView: View {
    let session: CDTestSession

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ScoreCircleView(
                    score: session.scorePercentage,
                    title: gradeText,
                    subtitle: "\(session.correctCount) / \(session.totalQuestions) 正确"
                )
                .padding(.top, 20)

                VStack(spacing: 12) {
                    ResultStatRow(
                        icon: "checkmark.circle.fill",
                        color: .appSuccess,
                        label: "正确",
                        value: "\(session.correctCount)"
                    )
                    ResultStatRow(
                        icon: "xmark.circle.fill",
                        color: .appDanger,
                        label: "错误",
                        value: "\(session.incorrectCount)"
                    )
                    ResultStatRow(
                        icon: "minus.circle.fill",
                        color: .gray,
                        label: "未答",
                        value: "\(session.skippedCount)"
                    )
                }
                .cardStyle()
                .padding(.horizontal)

                NavigationLink(destination: EmptyView()) {
                    Text("查看错题详情")
                }
                .secondaryButtonStyle()
                .padding(.horizontal)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("练习结果")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var gradeText: String {
        let score = session.scorePercentage
        for (grade, threshold) in Constants.gradeThresholds {
            if score >= threshold { return grade }
        }
        return Constants.defaultGrade
    }
}

struct ResultStatRow: View {
    let icon: String
    let color: Color
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.bold)
        }
    }
}
