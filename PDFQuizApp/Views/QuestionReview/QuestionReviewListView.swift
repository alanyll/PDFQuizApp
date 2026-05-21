import SwiftUI

struct QuestionReviewListView: View {
    let document: CDDocument
    let detectedQuestions: [DetectedQuestion]

    @State private var selectedQuestions: Set<UUID> = []
    @State private var editingQuestion: DetectedQuestion?
    @State private var questions: [DetectedQuestion]

    init(document: CDDocument, detectedQuestions: [DetectedQuestion]) {
        self.document = document
        self.detectedQuestions = detectedQuestions
        _questions = State(initialValue: detectedQuestions)
    }

    var body: some View {
        List {
            ForEach(questions) { question in
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(question.type.displayName)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.appPrimary.opacity(0.1))
                                .cornerRadius(4)

                            if question.confidence < Constants.detectionConfidenceThreshold {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.appWarning)
                                    .font(.caption)
                            }
                        }

                        Text(question.questionText)
                            .font(.subheadline)
                            .lineLimit(2)

                        Text("\(question.options.count) 个选项 · 第\(question.pageNumber)页")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: selectedQuestions.contains(question.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedQuestions.contains(question.id) ? .appPrimary : .gray)
                        .font(.title3)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedQuestions.contains(question.id) {
                        selectedQuestions.remove(question.id)
                    } else {
                        selectedQuestions.insert(question.id)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        questions.removeAll { $0.id == question.id }
                    } label: {
                        Label("删除", systemImage: "trash")
                    }

                    Button {
                        editingQuestion = question
                    } label: {
                        Label("编辑", systemImage: "pencil")
                    }
                    .tint(.appPrimary)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("检测结果")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("确认(\(selectedQuestions.count))") {
                    // Save confirmed questions to Core Data
                }
                .fontWeight(.semibold)
                .disabled(selectedQuestions.isEmpty)
            }
        }
        .sheet(item: $editingQuestion) { question in
            QuestionEditView(question: question) { updated in
                if let index = questions.firstIndex(where: { $0.id == updated.id }) {
                    questions[index] = updated
                }
            }
        }
    }
}
