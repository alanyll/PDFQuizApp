import SwiftUI

struct MockExamResultView: View {
    let score: Double
    let correctCount: Int
    let totalCount: Int
    let elapsedSeconds: Double

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ScoreCircleView(
                    score: score,
                    title: score >= 60 ? "考试通过" : "未通过",
                    subtitle: "\(correctCount) / \(totalCount) 正确"
                )

                VStack(spacing: 12) {
                    ResultStatRow(icon: "checkmark.circle.fill", color: .appSuccess, label: "正确", value: "\(correctCount)")
                    ResultStatRow(icon: "xmark.circle.fill", color: .appDanger, label: "错误", value: "\(totalCount - correctCount)")
                    ResultStatRow(icon: "clock", color: .appPrimary, label: "用时", value: timeString)
                }
                .cardStyle()
                .padding(.horizontal)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("考试结果")
    }

    private var timeString: String {
        let mins = Int(elapsedSeconds) / 60
        let secs = Int(elapsedSeconds) % 60
        return "\(mins)分\(secs)秒"
    }
}
