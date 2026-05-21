import SwiftUI

struct MockExamSessionView: View {
    let timeLimitMinutes: Int
    let questionCount: Int

    @Environment(\.dismiss) private var dismiss
    @State private var remainingSeconds: Int
    @State private var currentIndex = 0
    @State private var answers: [String?] = []
    @State private var showSubmitConfirm = false
    @State private var showResult = false

    init(timeLimitMinutes: Int, questionCount: Int) {
        self.timeLimitMinutes = timeLimitMinutes
        self.questionCount = questionCount
        _remainingSeconds = State(initialValue: timeLimitMinutes * 60)
        _answers = State(initialValue: Array(repeating: nil, count: questionCount))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MockExamTimerView(
                    remainingSeconds: remainingSeconds,
                    totalSeconds: timeLimitMinutes * 60
                )
                .padding()

                // Question area - placeholder
                VStack {
                    Text("第 \(currentIndex + 1) / \(questionCount) 题")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("题目加载中...")
                        .font(.body)

                    Spacer()
                }
                .cardStyle()
                .padding(.horizontal)

                // Navigation buttons
                HStack {
                    Button("上一题") {
                        if currentIndex > 0 { currentIndex -= 1 }
                    }
                    .disabled(currentIndex == 0)

                    Spacer()

                    if currentIndex < questionCount - 1 {
                        Button("下一题") {
                            currentIndex += 1
                        }
                    } else {
                        Button("提交") {
                            showSubmitConfirm = true
                        }
                        .foregroundColor(.appDanger)
                    }
                }
                .padding()
            }
            .navigationTitle("模拟考试")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("退出") { dismiss() }
                }
            }
        }
        .alert("确认提交", isPresented: $showSubmitConfirm) {
            Button("取消", role: .cancel) {}
            Button("提交") { showResult = true }
        } message: {
            Text("提交后将无法修改答案。确定要提交吗？")
        }
    }
}
