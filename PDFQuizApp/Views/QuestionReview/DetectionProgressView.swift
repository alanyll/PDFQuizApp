import SwiftUI

struct DetectionProgressView: View {
    let document: CDDocument
    @Environment(\.dismiss) private var dismiss
    @State private var isDetecting = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                if isDetecting {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("正在检测题目...")
                        .font(.headline)
                } else {
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.appPrimary)
                    Text("将要检测文档中的题目")
                        .font(.headline)
                    Text("检测将自动识别题目类型、选项和正确答案")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                if !isDetecting {
                    Button("开始检测") {
                        isDetecting = true
                        // Detection will be implemented in Phase 3
                    }
                    .primaryButtonStyle()
                    .padding(.horizontal)
                }

                Button("取消") { dismiss() }
                    .padding(.bottom)
            }
            .navigationTitle("检测题目")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
