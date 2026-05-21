import Foundation

/// Protocol for language-specific pattern providers
protocol QuestionPatternProviding {
    var questionStartPatterns: [NSRegularExpression] { get }
    var optionPatterns: [NSRegularExpression] { get }
    var fillInBlankPatterns: [NSRegularExpression] { get }
    var trueFalseIndicators: [String] { get }
    var multipleChoiceIndicators: [String] { get }
    var questionKeywords: [String] { get }
}

/// Core regex engine for detecting questions and options in text
final class QuestionPatternMatcher {

    struct QuestionCandidate {
        let text: String
        let range: NSRange
        let options: [OptionCandidate]
        let context: String?
    }

    struct OptionCandidate {
        let label: String
        let text: String
        let range: NSRange
    }

    private let cnProvider = ChinesePatternProvider()
    private let enProvider = EnglishPatternProvider()

    func findQuestionCandidates(in text: String) -> [QuestionCandidate] {
        let providers: [QuestionPatternProviding] = [cnProvider, enProvider]
        var allCandidates: [QuestionCandidate] = []

        for provider in providers {
            let candidates = findCandidates(in: text, provider: provider)
            allCandidates.append(contentsOf: candidates)
        }

        // Deduplicate by range overlap and sort by position
        return deduplicateAndSort(allCandidates, in: text)
    }

    private func findCandidates(in text: String, provider: QuestionPatternProviding) -> [QuestionCandidate] {
        var candidates: [QuestionCandidate] = []
        let nsText = text as NSString

        for pattern in provider.questionStartPatterns {
            let matches = pattern.matches(in: text, range: NSRange(location: 0, length: nsText.length))

            for match in matches {
                let matchRange = match.range

                // Extract full question text up to the next question or reasonable boundary
                let searchStart = matchRange.location + matchRange.length
                var searchEnd = min(searchStart + 2000, nsText.length)

                // Look ahead for next question start or end of section
                let remaining = nsText.substring(from: searchStart)
                for nextPattern in provider.questionStartPatterns {
                    if let nextMatch = nextPattern.firstMatch(in: remaining, range: NSRange(location: 0, length: remaining.count)) {
                        searchEnd = searchStart + nextMatch.range.location
                        break
                    }
                }

                let questionRange = NSRange(location: matchRange.location, length: searchEnd - matchRange.location)
                let fullText = nsText.substring(with: questionRange)
                let questionText = nsText.substring(with: matchRange)

                // Find options within the question range
                let options = findOptions(in: fullText, provider: provider, baseOffset: matchRange.location)

                // Check for keywords or question marks
                let hasQuestionMark = questionText.contains("?") || questionText.contains("？")
                let hasKeyword = provider.questionKeywords.contains { questionText.lowercased().contains($0.lowercased()) }

                if hasQuestionMark || hasKeyword || !options.isEmpty {
                    candidates.append(QuestionCandidate(
                        text: questionText,
                        range: matchRange,
                        options: options,
                        context: fullText
                    ))
                }
            }
        }

        return candidates
    }

    private func findOptions(in text: String, provider: QuestionPatternProviding, baseOffset: Int) -> [OptionCandidate] {
        var options: [OptionCandidate] = []
        let nsText = text as NSString

        for pattern in provider.optionPatterns {
            let matches = pattern.matches(in: text, range: NSRange(location: 0, length: nsText.length))
            for match in matches {
                let fullLine = nsText.substring(with: match.range)
                // Extract label (A, B, 1, etc.) and text
                if let regex = try? NSRegularExpression(pattern: "^([A-Fa-f\\d]+)[\.\\)、]\\s*(.*)") {
                    if let labelMatch = regex.firstMatch(in: fullLine, range: NSRange(location: 0, length: fullLine.count)) {
                        let label = nsText.substring(with: labelMatch.range(at: 1))
                        let optText = labelMatch.range(at: 2).location != NSNotFound
                            ? nsText.substring(with: labelMatch.range(at: 2))
                            : fullLine
                        options.append(OptionCandidate(
                            label: label,
                            text: optText,
                            range: match.range
                        ))
                    }
                }
            }
        }

        return options
    }

    private func deduplicateAndSort(_ candidates: [QuestionCandidate], in text: String) -> [QuestionCandidate] {
        let sorted = candidates.sorted { $0.range.location < $1.range.location }
        var result: [QuestionCandidate] = []

        for candidate in sorted {
            // Check if this candidate overlaps with the last added one
            if let last = result.last,
               candidate.range.location < last.range.location + last.range.length {
                // Keep the one with more options
                if candidate.options.count > last.options.count {
                    result[result.count - 1] = candidate
                }
            } else {
                result.append(candidate)
            }
        }

        return result
    }
}
