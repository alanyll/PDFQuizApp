import SwiftUI

extension Color {
    static let appPrimary = Color(red: 0.20, green: 0.40, blue: 0.90)
    static let appSecondary = Color(red: 0.95, green: 0.55, blue: 0.20)
    static let appSuccess = Color(red: 0.20, green: 0.80, blue: 0.40)
    static let appDanger = Color(red: 0.90, green: 0.20, blue: 0.20)
    static let appWarning = Color(red: 0.95, green: 0.75, blue: 0.15)
    static let appBackground = Color(uiColor: .systemGroupedBackground)
    static let appCard = Color(uiColor: .systemBackground)

    // Option button states
    static let optionDefault = Color(uiColor: .systemGray6)
    static let optionSelected = Color.appPrimary.opacity(0.15)
    static let optionCorrect = Color.appSuccess.opacity(0.15)
    static let optionWrong = Color.appDanger.opacity(0.15)
}
