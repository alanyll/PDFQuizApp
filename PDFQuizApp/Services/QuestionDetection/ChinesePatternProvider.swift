import Foundation

struct ChinesePatternProvider: QuestionPatternProviding {
    var questionStartPatterns: [NSRegularExpression] {
        patterns([
            // Numbered: 1. 2) 3、
            #"^\d+[\.\)、]\s*"#,
            // Chinese numerals: 一、 二． 三.
            #"^[一二三四五六七八九十]+[、．\.]\s*"#,
            // Parenthetical numbering: （一） (1)
            #"^（[\d一二三四五六七八九十]+）\s*"#,
            #"^\([\d]+\)\s*"#,
            // Question prefix: 问题1. 问1.
            #"^问(?:题)?\s*\d+[\.:、]\s*"#,
            // Circled numbers: ①-⑳
            #"^[①-⑳]\s*"#,
        ])
    }

    var optionPatterns: [NSRegularExpression] {
        patterns([
            // Lettered: A. B) C、
            #"^[A-Fa-f][\.\、\)]\s*"#,
            // Parenthetical letters: (A) （B）
            #"^\([a-fA-F]\)\s*"#,
            #"^（[a-fA-F]）\s*"#,
        ])
    }

    var fillInBlankPatterns: [NSRegularExpression] {
        patterns([
            #"_{3,}"#,
            #"（\s*）"#,
            #"\(\s*\)"#,
        ])
    }

    var trueFalseIndicators: [String] {
        ["正确", "错误", "对", "错"]
    }

    var multipleChoiceIndicators: [String] {
        ["多选", "多项选择", "不定项"]
    }

    var questionKeywords: [String] {
        [
            "以下", "正确", "错误", "哪个", "哪项", "哪一",
            "下列", "选择", "不属于", "属于", "什么是",
            "是指", "最", "主要", "特点", "正确的是",
            "错误的是", "不正确", "恰当", "不包括",
        ]
    }

    private func patterns(_ regexStrings: [String]) -> [NSRegularExpression] {
        regexStrings.compactMap {
            try? NSRegularExpression(pattern: $0, options: [.anchorsMatchLines])
        }
    }
}
