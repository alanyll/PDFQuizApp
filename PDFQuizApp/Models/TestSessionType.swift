import Foundation

enum TestSessionType: String, CaseIterable, Codable {
    case practice = "practice"
    case mockExam = "mockExam"

    var displayName: String {
        switch self {
        case .practice: return "练习模式"
        case .mockExam: return "模拟考试"
        }
    }
}
