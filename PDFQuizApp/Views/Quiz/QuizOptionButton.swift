import SwiftUI

struct QuizOptionButton: View {
    let label: String
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?  // nil when result not shown
    let showResult: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .frame(width: 28, height: 28)
                    .background(labelBackground)
                    .foregroundColor(labelForeground)
                    .cornerRadius(14)

                Text(text)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)

                Spacer()

                if showResult {
                    Image(systemName: statusIcon)
                        .foregroundColor(statusColor)
                }
            }
            .padding(12)
            .background(backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {
        if showResult, let isCorrect {
            return isCorrect ? .optionCorrect : (isSelected ? .optionWrong : .clear)
        }
        return isSelected ? .optionSelected : .optionDefault
    }

    private var borderColor: Color {
        if showResult, let isCorrect {
            return isCorrect ? .appSuccess : (isSelected ? .appDanger : .clear)
        }
        return isSelected ? .appPrimary : .clear
    }

    private var borderWidth: CGFloat {
        (showResult && isCorrect == true) || isSelected ? 1.5 : 0
    }

    private var labelBackground: Color {
        if showResult, let isCorrect {
            return isCorrect ? .appSuccess : (isSelected ? .appDanger : .gray.opacity(0.3))
        }
        return isSelected ? .appPrimary : .gray.opacity(0.2)
    }

    private var labelForeground: Color {
        if showResult, let isCorrect {
            return isCorrect ? .white : (isSelected ? .white : .secondary)
        }
        return isSelected ? .white : .primary
    }

    private var statusIcon: String {
        if let isCorrect {
            return isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
        }
        return ""
    }

    private var statusColor: Color {
        if let isCorrect {
            return isCorrect ? .appSuccess : .appDanger
        }
        return .clear
    }
}
