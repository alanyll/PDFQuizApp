import SwiftUI

struct ScoreCircleView: View {
    let score: Double
    let title: String
    let subtitle: String

    @State private var animationProgress: CGFloat = 0

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 12)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: animationProgress * CGFloat(score / 100.0))
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text(String(format: "%.0f", score))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(scoreColor)
                    Text("分")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(scoreColor)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
    }

    private var scoreColor: Color {
        switch score {
        case 90...: return .appSuccess
        case 70..<90: return .appPrimary
        case 60..<70: return .appWarning
        default: return .appDanger
        }
    }
}
