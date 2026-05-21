import SwiftUI

struct QuizProgressBar: View {
    let current: Int
    let total: Int
    let correctCount: Int
    let incorrectCount: Int

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("第 \(current) / \(total) 题")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("正确: \(correctCount)  错误: \(incorrectCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appPrimary)
                        .frame(width: geo.size.width * CGFloat(current) / CGFloat(max(total, 1)), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}
