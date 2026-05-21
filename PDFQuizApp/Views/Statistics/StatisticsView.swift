import SwiftUI
import CoreData

struct StatisticsView: View {
    @FetchRequest<CDTestSession>(
        sortDescriptors: [NSSortDescriptor(keyPath: \CDTestSession.startedAt, ascending: false)],
        predicate: NSPredicate(format: "completedAt != nil")
    ) private var sessions

    var body: some View {
        Group {
            if sessions.isEmpty {
                EmptyStateView(
                    icon: "chart.bar.xaxis",
                    title: "暂无数据",
                    message: "完成练习或模拟考试后，统计数据会显示在这里"
                )
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Overall stats
                        HStack(spacing: 12) {
                            StatCard(
                                title: "总练习次数",
                                value: "\(sessions.count)",
                                icon: "book.fill",
                                color: .appPrimary
                            )
                            StatCard(
                                title: "平均正确率",
                                value: String(format: "%.0f%%", averageScore),
                                icon: "target",
                                color: .appSuccess
                            )
                        }
                        .padding(.horizontal)

                        // Recent sessions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("最近练习")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(sessions.prefix(10)) { session in
                                RecentSessionRow(session: session)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.appBackground)
            }
        }
        .navigationTitle("学习进度")
    }

    private var averageScore: Double {
        guard !sessions.isEmpty else { return 0 }
        let total = sessions.reduce(0.0) { $0 + $1.scorePercentage }
        return total / Double(sessions.count)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

struct RecentSessionRow: View {
    let session: CDTestSession

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.type.flatMap { TestSessionType(rawValue: $0)?.displayName } ?? "练习")
                    .font(.subheadline)
                    .fontWeight(.medium)

                if let date = session.startedAt {
                    Text(date.formatted(date: .numeric, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text(String(format: "%.0f%%", session.scorePercentage))
                .font(.headline)
                .foregroundColor(scoreColor)
        }
        .padding(12)
        .background(Color.appCard)
        .cornerRadius(8)
    }

    private var scoreColor: Color {
        let score = session.scorePercentage
        switch score {
        case 90...: return .appSuccess
        case 70..<90: return .appPrimary
        case 60..<70: return .appWarning
        default: return .appDanger
        }
    }
}
