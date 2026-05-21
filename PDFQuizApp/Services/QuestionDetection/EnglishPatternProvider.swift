import Foundation

struct EnglishPatternProvider: QuestionPatternProviding {
    var questionStartPatterns: [NSRegularExpression] {
        patterns([
            // Numbered: 1. 2) 3
            #"^\d+[\.\)]\s*"#,
            // Q-prefix: Q1. Question 1.
            #"^Q(?:uestion)?\s*\d+[\.:]\s*"#,
            // Parenthetical: (1)
            #"^\(\d+\)\s*"#,
            // Roman numerals: I. II) IV.
            #"^[IVX]+[\.\)]\s*"#,
        ])
    }

    var optionPatterns: [NSRegularExpression] {
        patterns([
            // Lettered: A. B) C
            #"^[A-Fa-f][\.\、\)]\s*"#,
            // Parenthetical: (A) (a)
            #"^\([a-fA-F]\)\s*"#,
        ])
    }

    var fillInBlankPatterns: [NSRegularExpression] {
        patterns([
            #"_{3,}"#,
            #"\(\s*\)"#,
        ])
    }

    var trueFalseIndicators: [String] {
        ["true", "false", "t/f", "true or false"]
    }

    var multipleChoiceIndicators: [String] {
        ["select all that apply", "choose all", "multiple choice", "check all"]
    }

    var questionKeywords: [String] {
        [
            "which", "what", "when", "where", "why", "how",
            "select", "choose", "correct", "following",
            "not", "except", "best", "most", "least",
            "describe", "explain", "define", "identify",
        ]
    }

    private func patterns(_ regexStrings: [String]) -> [NSRegularExpression] {
        regexStrings.compactMap {
            try? NSRegularExpression(pattern: $0, options: [.anchorsMatchLines, .caseInsensitive])
        }
    }
}
