import Foundation

enum QuestionType: String, CaseIterable, Codable {
    case singleChoice = "singleChoice"
    case multipleChoice = "multipleChoice"
    case trueFalse = "trueFalse"
    case fillInBlank = "fillInBlank"

    var displayName: String {
        switch self {
        case .singleChoice: return "单选题"
        case .multipleChoice: return "多选题"
        case .trueFalse: return "判断题"
        case .fillInBlank: return "填空题"
        }
    }
}
