import SwiftUI

struct QuestionEditView: View {
    let question: DetectedQuestion
    let onSave: (DetectedQuestion) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var questionText: String
    @State private var selectedType: QuestionType
    @State private var options: [DetectedOption]
    @State private var correctLabels: Set<String>

    init(question: DetectedQuestion, onSave: @escaping (DetectedQuestion) -> Void) {
        self.question = question
        self.onSave = onSave
        _questionText = State(initialValue: question.questionText)
        _selectedType = State(initialValue: question.type)
        _options = State(initialValue: question.options)
        _correctLabels = State(initialValue: [])
    }

    var body: some View {
        NavigationView {
            Form {
                Section("题目") {
                    TextEditor(text: $questionText)
                        .frame(minHeight: 80)

                    Picker("题型", selection: $selectedType) {
                        ForEach(QuestionType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }

                Section("选项") {
                    ForEach(options.indices, id: \.self) { index in
                        HStack {
                            Text(options[index].label)
                                .fontWeight(.bold)
                                .frame(width: 24)

                            TextField("选项内容", text: Binding(
                                get: { options[index].text },
                                set: { options[index].text = $0 }
                            ))

                            Button(action: {
                                if correctLabels.contains(options[index].label) {
                                    correctLabels.remove(options[index].label)
                                } else {
                                    if selectedType == .singleChoice || selectedType == .trueFalse {
                                        correctLabels = [options[index].label]
                                    } else {
                                        correctLabels.insert(options[index].label)
                                    }
                                }
                            }) {
                                Image(systemName: correctLabels.contains(options[index].label)
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                    .foregroundColor(correctLabels.contains(options[index].label)
                                                     ? .appSuccess : .gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        options.remove(atOffsets: indexSet)
                    }

                    Button("添加选项") {
                        let nextLabel = nextOptionLabel
                        options.append(DetectedOption(label: nextLabel, text: "", orderIndex: options.count))
                    }
                }

                Section {
                    Text("点击选项左侧圆圈标记为正确答案")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("编辑题目")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        var updated = question
                        updated.questionText = questionText
                        updated.type = selectedType
                        updated.options = options
                        onSave(updated)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var nextOptionLabel: String {
        let existing = Set(options.map { $0.label.uppercased() })
        for label in "ABCDEFGH" {
            if !existing.contains(String(label)) {
                return String(label)
            }
        }
        return "\(options.count + 1)"
    }
}
