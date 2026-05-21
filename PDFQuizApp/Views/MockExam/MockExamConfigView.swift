import SwiftUI

struct MockExamConfigView: View {
    @State private var selectedTime = 30
    @State private var questionCount = 20
    @State private var startExam = false

    var body: some View {
        Form {
            Section("考试设置") {
                Picker("时间限制", selection: $selectedTime) {
                    ForEach(Constants.mockExamTimeOptions, id: \.self) { minutes in
                        Text("\(minutes) 分钟").tag(minutes)
                    }
                }
                Stepper("题目数量: \(questionCount)", value: $questionCount, in: 1...100)
            }

            Section("考试说明") {
                Text("模拟考试一旦开始将计时进行。时间到后自动提交。考试期间请勿切换应用。")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Section {
                Button("开始模拟考试") {
                    startExam = true
                }
                .primaryButtonStyle()
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("模拟考试")
        .fullScreenCover(isPresented: $startExam) {
            MockExamSessionView(
                timeLimitMinutes: selectedTime,
                questionCount: questionCount
            )
        }
    }
}
