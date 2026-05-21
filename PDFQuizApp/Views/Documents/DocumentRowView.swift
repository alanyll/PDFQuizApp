import SwiftUI

struct DocumentRowView: View {
    @ObservedObject var document: CDDocument

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.title2)
                .foregroundColor(.appPrimary)
                .frame(width: 40, height: 40)
                .background(Color.appPrimary.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(document.title ?? "未命名文档")
                    .font(.headline)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label("\(document.pageCount)页", systemImage: "doc.text")
                    if document.questionCount > 0 {
                        Label("\(document.questionCount)题", systemImage: "questionmark.circle")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

            Spacer()

            if let status = ImportStatus(rawValue: document.importStatus ?? "") {
                StatusBadge(status: status)
            }
        }
        .padding(.vertical, 4)
    }
}

struct StatusBadge: View {
    let status: ImportStatus

    var body: some View {
        Text(status.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(4)
    }

    private var backgroundColor: Color {
        switch status {
        case .pending: return .gray.opacity(0.15)
        case .processing: return .appWarning.opacity(0.15)
        case .completed: return .appSuccess.opacity(0.15)
        case .failed: return .appDanger.opacity(0.15)
        }
    }

    private var foregroundColor: Color {
        switch status {
        case .pending: return .gray
        case .processing: return .appWarning
        case .completed: return .appSuccess
        case .failed: return .appDanger
        }
    }
}
