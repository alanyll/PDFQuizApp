import SwiftUI

struct MockExamTimerView: View {
    let remainingSeconds: Int
    let totalSeconds: Int

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(timerColor)
                        .frame(
                            width: geo.size.width * CGFloat(remainingSeconds) / CGFloat(max(totalSeconds, 1)),
                            height: 8
                        )
                }
            }
            .frame(height: 8)

            HStack {
                Image(systemName: timerIcon)
                Text(timeString)
            }
            .font(.title3.monospacedDigit())
            .fontWeight(.semibold)
            .foregroundColor(timerColor)
        }
    }

    private var timeString: String {
        let mins = remainingSeconds / 60
        let secs = remainingSeconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    private var timerColor: Color {
        let ratio = Double(remainingSeconds) / Double(totalSeconds)
        switch ratio {
        case 0.5...: return .appSuccess
        case 0.15..<0.5: return .appWarning
        default: return .appDanger
        }
    }

    private var timerIcon: String {
        let ratio = Double(remainingSeconds) / Double(totalSeconds)
        return ratio < 0.15 ? "exclamationmark.triangle.fill" : "clock"
    }
}
