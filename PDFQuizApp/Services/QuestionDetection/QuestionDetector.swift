import Foundation

/// Lightweight struct representing a detected question (not yet saved to Core Data)
struct DetectedQuestion: Identifiable {
    let id = UUID()
    var questionText: String
    var type: QuestionType
    var options: [DetectedOption]
    var pageNumber: Int
    var confidence: Double
    var sourceContext: String?
    var explanation: String?
    var difficulty: QuestionDifficulty
}

struct DetectedOption: Identifiable {
    let id = UUID()
    var label: String
    var text: String
    var orderIndex: Int
}

/// Pipeline orchestrator for question detection
final class QuestionDetector {
    private let matcher = QuestionPatternMatcher()
    private let scorer = QuestionConfidenceScorer()

    func detectQuestions(from text: String, pageNumber: Int) -> [DetectedQuestion] {
        let candidates = matcher.findQuestionCandidates(in: text)
        return candidates.compactMap { candidate in
            let confidence = scorer.score(candidate)
            guard confidence >= Constants.detectionConfidenceThreshold else { return nil }

            return DetectedQuestion(
                questionText: candidate.text,
                type: classifyType(candidate.text, options: candidate.options),
                options: candidate.options.enumerated().map { index, opt in
                    DetectedOption(label: opt.label, text: opt.text, orderIndex: index)
                },
                pageNumber: pageNumber,
                confidence: confidence,
                sourceContext: candidate.context,
                difficulty: .medium
            )
        }
    }

    private func classifyType(_ text: String, options: [QuestionPatternMatcher.OptionCandidate]) -> QuestionType {
        let lowercased = text.lowercased()
        let cn = text

        // Check for true/false
        let tfIndicators = ["true", "false", "正确", "错误", "对", "错"]
        if tfIndicators.contains(where: { lowercased.contains($0) || cn.contains($0) }) && options.count <= 2 {
            return .trueFalse
        }

        // Check for multiple choice
        let mcIndicators = ["select all", "multiple", "多项", "多选", "choose all"]
        if mcIndicators.contains(where: { lowercased.contains($0) || cn.contains($0) }) {
            return .multipleChoice
        }

        // Check for fill in blank
        let blanks = ["___", "____", "（  ）", "(  )", "___"]
        if blanks.contains(where: { text.contains($0) }) && options.isEmpty {
            return .fillInBlank
        }

        return .singleChoice
    }
}
