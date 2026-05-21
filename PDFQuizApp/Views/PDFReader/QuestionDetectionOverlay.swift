import SwiftUI

struct QuestionDetectionOverlay: View {
    let questions: [DetectedQuestion]
    let currentPage: Int

    var body: some View {
        let pageQuestions = questions.filter { $0.pageNumber == currentPage }

        if !pageQuestions.isEmpty {
            VStack {
                HStack {
                    Text("检测到 \(pageQuestions.count) 个题目")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    Spacer()
                }
                .padding(8)
                Spacer()
            }
        }
    }
}
