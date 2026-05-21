import SwiftUI

struct WrongAnswerReviewView: View {
    let wrongAnswers: [CDWrongAnswer]

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if currentIndex < wrongAnswers.count {
                    Text("第 \(currentIndex + 1) / \(wrongAnswers.count) 题")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top)

                    ScrollView {
                        if let question = wrongAnswers[currentIndex].question {
                            QuizQuestionCardView(
                                question: question,
                                selectedLabels: [],
                                showResult: false,
                                onToggle: { _ in }
                            )
                            .padding()
                        }
                    }

                    HStack {
                        Button("上一题") {
                            if currentIndex > 0 { currentIndex -= 1 }
                        }
                        .disabled(currentIndex == 0)

                        Spacer()

                        if currentIndex < wrongAnswers.count - 1 {
                            Button("下一题") { currentIndex += 1 }
                        } else {
                            Button("完成") { dismiss() }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.appBackground)
            .navigationTitle("错题复习")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") { dismiss() }
                }
            }
        }
    }
}
