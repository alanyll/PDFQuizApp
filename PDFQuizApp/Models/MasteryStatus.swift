import Foundation

enum MasteryStatus: String, CaseIterable, Codable {
    case new = "new"
    case learning = "learning"
    case reviewing = "reviewing"
    case mastered = "mastered"

    var displayName: String {
        switch self {
        case .new: return "新错题"
        case .learning: return "学习中"
        case .reviewing: return "复习中"
        case .mastered: return "已掌握"
        }
    }

    var nextStatus: MasteryStatus {
        switch self {
        case .new: return .learning
        case .learning: return .reviewing
        case .reviewing: return .mastered
        case .mastered: return .mastered
        }
    }
}
