import SwiftUI

struct QuizSessionView: View {
    let document: CDDocument
    let questionCount: Int
    @StateObject private var viewModel: QuizSessionViewModel
    @State private var showResult = false

    init(document: CDDocument, questionCount: Int) {
        self.document = document
        self.questionCount = questionCount
        _viewModel = StateObject(wrappedValue: QuizSessionViewModel(
            document: document, questionCount: questionCount
        ))
    }

    var body: some View {
        VStack(spacing: 0) {
            QuizProgressBar(
                current: viewModel.currentIndex + 1,
                total: viewModel.questions.count,
                correctCount: viewModel.correctCount,
                incorrectCount: viewModel.incorrectCount
            )
            .padding(.horizontal)
            .padding(.top, 8)

            if let question = viewModel.currentQuestion {
                ScrollView {
                    QuizQuestionCardView(
                        question: question,
                        selectedLabels: viewModel.selectedLabels,
                        showResult: viewModel.showAnswerResult,
                        onToggle: { label in
                            viewModel.toggleSelection(label)
                        }
                    )
                    .padding()
                }

                Button(action: {
                    if viewModel.showAnswerResult {
                        viewModel.advanceToNext()
                        if viewModel.isComplete {
                            showResult = true
                        }
                    } else {
                        viewModel.submitAnswer()
                    }
                }) {
                    Text(viewModel.showAnswerResult
                         ? (viewModel.currentIndex + 1 >= viewModel.questions.count ? "查看结果" : "下一题")
                         : "提交答案")
                }
                .primaryButtonStyle(isEnabled: viewModel.canSubmit)
                .disabled(!viewModel.canSubmit)
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("练习")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showResult) {
            QuizResultView(session: viewModel.session)
        }
    }
}
