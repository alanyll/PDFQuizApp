import SwiftUI

struct QuizConfigView: View {
    let document: CDDocument
    @State private var questionCount = 10
    @State private var startQuiz = false

    var body: some View {
        Form {
            Section("练习设置") {
                Stepper("题目数量: \(questionCount)", value: $questionCount, in: 1...maxQuestions)
            }

            Section {
                Button("开始练习") {
                    startQuiz = true
                }
                .primaryButtonStyle()
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("练习配置")
        .navigationDestination(isPresented: $startQuiz) {
            QuizSessionView(document: document, questionCount: questionCount)
        }
    }

    private var maxQuestions: Int {
        max(1, Int(document.questionCount))
    }
}
