import SwiftUI

struct DocumentDetailView: View {
    @ObservedObject var document: CDDocument
    @State private var showPDFReader = false
    @State private var showDetectProgress = false
    @State private var showQuizConfig = false
    @State private var showMockExamConfig = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Document info card
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.appPrimary)
                        .frame(width: 80, height: 80)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(16)

                    Text(document.title ?? "未命名文档")
                        .font(.title2)
                        .fontWeight(.bold)

                    HStack(spacing: 16) {
                        Label("\(document.pageCount) 页", systemImage: "doc.text")
                        if document.questionCount > 0 {
                            Label("\(document.questionCount) 题", systemImage: "questionmark.circle")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .cardStyle()

                // Actions
                VStack(spacing: 12) {
                    Button(action: { showPDFReader = true }) {
                        HStack {
                            Image(systemName: "eye")
                            Text("查看PDF")
                        }
                    }
                    .secondaryButtonStyle()

                    Button(action: { showDetectProgress = true }) {
                        HStack {
                            Image(systemName: "text.magnifyingglass")
                            Text("检测题目")
                        }
                    }
                    .secondaryButtonStyle()

                    if document.questionCount > 0 {
                        Button(action: { showQuizConfig = true }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("开始练习")
                            }
                        }
                        .primaryButtonStyle()

                        Button(action: { showMockExamConfig = true }) {
                            HStack {
                                Image(systemName: "timer")
                                Text("模拟考试")
                            }
                        }
                        .secondaryButtonStyle()
                    }
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("文档详情")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPDFReader) {
            PDFReaderView(document: document)
        }
        .sheet(isPresented: $showDetectProgress) {
            DetectionProgressView(document: document)
        }
        .navigationDestination(isPresented: $showQuizConfig) {
            QuizConfigView(document: document)
        }
        .navigationDestination(isPresented: $showMockExamConfig) {
            MockExamConfigView()
        }
    }
}
