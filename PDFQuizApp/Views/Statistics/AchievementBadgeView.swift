import SwiftUI

struct AchievementBadgeView: View {
    let badge: AchievementBadge

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(badge.isUnlocked ? badge.color.opacity(0.15) : Color.gray.opacity(0.1))
                    .frame(width: 64, height: 64)

                Image(systemName: badge.icon)
                    .font(.title2)
                    .foregroundColor(badge.isUnlocked ? badge.color : .gray.opacity(0.5))
            }

            Text(badge.title)
                .font(.caption2)
                .multilineTextAlignment(.center)

            Text(badge.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
}

struct AchievementBadge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

extension AchievementBadge {
    static let samples: [AchievementBadge] = [
        AchievementBadge(title: "初出茅庐", description: "完成第一次练习", icon: "1.circle.fill", color: .appSuccess, isUnlocked: true),
        AchievementBadge(title: "持之以恒", description: "连续7天练习", icon: "7.circle.fill", color: .appPrimary, isUnlocked: true),
        AchievementBadge(title: "学霸", description: "正确率90%+", icon: "star.fill", color: .appWarning, isUnlocked: false),
        AchievementBadge(title: "题海战术", description: "完成1000题", icon: "books.vertical.fill", color: .appSecondary, isUnlocked: false),
        AchievementBadge(title: "完美通过", description: "模拟考试满分", icon: "crown.fill", color: .appDanger, isUnlocked: false),
    ]
}
