import Foundation

enum Constants {
    static let appName = "PDF答题助手"
    static let maxOptionsPerQuestion = 8
    static let minOptionsPerQuestion = 2
    static let maxQuestionTextLength = 2000
    static let minQuestionTextLength = 5
    static let detectionConfidenceThreshold = 0.5

    // Spaced repetition intervals (days)
    static let spacedRepetitionIntervals: [Int] = [1, 2, 4, 7, 14, 30, 60, 120]
    static let masteryThresholdCorrectCount = 3

    // Mock exam time limits (minutes)
    static let mockExamTimeOptions: [Int] = [15, 30, 45, 60, 90, 120]

    // Scoring
    static let gradeThresholds: [(grade: String, threshold: Double)] = [
        ("A", 90), ("B", 80), ("C", 70), ("D", 60)
    ]
    static let defaultGrade = "F"

    // File
    static let documentsSubdirectory = "ImportedPDFs"
}
