import Foundation

extension String {
    /// Normalize text for question detection: collapse whitespace, convert fullwidth chars
    var normalized: String {
        var result = self
        // Fullwidth digits → halfwidth
        let fullwidthDigits: [Character: Character] = [
            "０": "0", "１": "1", "２": "2", "３": "3", "４": "4",
            "５": "5", "６": "6", "７": "7", "８": "8", "９": "9"
        ]
        for (fw, hw) in fullwidthDigits {
            result = result.replacingOccurrences(of: String(fw), with: String(hw))
        }
        // Fullwidth letters → halfwidth
        let fullwidthUpper: [Character: Character] = [
            "Ａ": "A", "Ｂ": "B", "Ｃ": "C", "Ｄ": "D", "Ｅ": "E", "Ｆ": "F"
        ]
        for (fw, hw) in fullwidthUpper {
            result = result.replacingOccurrences(of: String(fw), with: String(hw))
        }
        // Collapse multiple whitespace to single space
        if let regex = try? NSRegularExpression(pattern: "[ \\t]+", options: []) {
            result = regex.stringByReplacingMatches(
                in: result, range: NSRange(result.startIndex..., in: result),
                withTemplate: " "
            )
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Check if line matches a typical question-end pattern
    var endsWithQuestionMark: Bool {
        trimmingCharacters(in: .whitespaces).hasSuffix("?")
            || trimmingCharacters(in: .whitespaces).hasSuffix("？")
    }

    /// Remove common header/footer artifacts from extracted text
    var strippedHeadersFooters: String {
        let lines = self.components(separatedBy: .newlines)
        guard lines.count > 3 else { return self }
        // Skip first 2 and last 2 lines if they look like headers/footers (short, numeric-heavy)
        var kept: [String] = []
        for (i, line) in lines.enumerated() {
            if i < 2 || i > lines.count - 3 {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                let digitRatio = Double(trimmed.filter { $0.isNumber }.count) / max(Double(trimmed.count), 1)
                if trimmed.count < 30 || digitRatio > 0.5 {
                    continue
                }
            }
            kept.append(line)
        }
        return kept.joined(separator: "\n")
    }

    /// Extract text content from a line, stripping the numbering prefix
    var stripNumberPrefix: String {
        let patterns: [String] = [
            "^[\\d一二三四五六七八九十]+[\.\\)、．]\\s*",
            "^\\(\\d+\\)\\s*",
            "^（[\\d一二三四五六七八九十]+）\\s*",
            "^Q(?:uestion)?\\s*\\d+[\.:]\\s*",
            "^[①-⑳]\\s*",
            "^[IVX]+[\.\\)]\\s*",
            "^[A-Fa-f][\.\\)、]\\s*"
        ]
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let range = NSRange(startIndex..., in: self)
                if let match = regex.firstMatch(in: self, range: range) {
                    let result = regex.stringByReplacingMatches(
                        in: self, range: range, withTemplate: ""
                    )
                    return result.trimmingCharacters(in: .whitespaces)
                }
            }
        }
        return self
    }
}
