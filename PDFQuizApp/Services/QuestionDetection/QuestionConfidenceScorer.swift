import Foundation

final class QuestionConfidenceScorer {

    func score(_ candidate: QuestionPatternMatcher.QuestionCandidate) -> Double {
        var score = 0.0

        // Question text ends with question mark
        if candidate.text.contains("?") || candidate.text.contains("？") {
            score += 0.3
        }

        // Has at least 2 valid options
        if candidate.options.count >= 2 {
            score += 0.3
        }

        // Optimal option count (3-6)
        let optionCount = candidate.options.count
        if optionCount >= 3 && optionCount <= 6 {
            score += 0.2
        } else if optionCount >= 2 && optionCount <= 8 {
            score += 0.1
        }

        // Consistent option labeling
        if hasConsistentLabels(candidate.options) {
            score += 0.1
        }

        // Reasonable text length (10-500 chars)
        let textLength = candidate.text.count
        if textLength >= 10 && textLength <= 500 {
            score += 0.1
        } else if textLength > 2000 {
            score -= 0.2
        }

        return min(max(score, 0.0), 1.0)
    }

    private func hasConsistentLabels(_ options: [QuestionPatternMatcher.OptionCandidate]) -> Bool {
        guard options.count >= 2 else { return false }
        let labels = options.map { $0.label.uppercased() }

        // Check if all labels are sequential letters (A, B, C, D...)
        let letters = "ABCDEFGH"
        for (i, label) in labels.enumerated() {
            let expectedIndex = letters.index(letters.startIndex, offsetBy: i)
            if String(letters[expectedIndex]) != label {
                return false
            }
        }
        return true
    }
}
