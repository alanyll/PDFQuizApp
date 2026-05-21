import Foundation

struct ScoringEngine {

    func calculateScore(correct: Int, total: Int) -> Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total) * 100.0
    }

    func assignGrade(score: Double) -> String {
        for (grade, threshold) in Constants.gradeThresholds {
            if score >= threshold {
                return grade
            }
        }
        return Constants.defaultGrade
    }

    func calculateStats(from sessions: [CDTestSession]) -> SessionStats {
        let total = sessions.count
        let averageScore = total > 0
            ? sessions.reduce(0.0) { $0 + $1.scorePercentage } / Double(total)
            : 0
        let totalQuestions = sessions.reduce(0) { $0 + Int($1.totalQuestions) }
        let totalCorrect = sessions.reduce(0) { $0 + Int($1.correctCount) }
        let totalTimeSpent = sessions.reduce(0.0) { $0 + $1.elapsedSeconds }

        return SessionStats(
            totalSessions: total,
            averageScore: averageScore,
            totalQuestions: totalQuestions,
            totalCorrect: totalCorrect,
            totalTimeSpent: totalTimeSpent
        )
    }
}

struct SessionStats {
    let totalSessions: Int
    let averageScore: Double
    let totalQuestions: Int
    let totalCorrect: Int
    let totalTimeSpent: Double
}
