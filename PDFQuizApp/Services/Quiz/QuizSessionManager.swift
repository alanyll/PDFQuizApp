import Foundation
import CoreData

@MainActor
final class QuizSessionManager {
    private let context: NSManagedObjectContext
    private var session: CDTestSession?

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func createSession(
        document: CDDocument,
        questionCount: Int,
        type: TestSessionType = .practice
    ) -> CDTestSession {
        let ses = CDTestSession(context: context)
        ses.id = UUID()
        ses.type = type.rawValue
        ses.startedAt = Date()
        ses.totalQuestions = Int16(questionCount)
        self.session = ses
        return ses
    }

    func recordAnswer(
        question: CDQuestion,
        selectedLabels: [String],
        isCorrect: Bool,
        session: CDTestSession
    ) {
        let answer = CDUserAnswer(context: context)
        answer.id = UUID()
        answer.selectedAnswer = selectedLabels as NSObject
        answer.isCorrect = isCorrect
        answer.answeredAt = Date()
        answer.session = session
        answer.question = question
    }

    func completeSession(_ session: CDTestSession, correctCount: Int, incorrectCount: Int, answeredCount: Int) {
        session.completedAt = Date()
        session.correctCount = Int16(correctCount)
        session.incorrectCount = Int16(incorrectCount)
        session.answeredQuestions = Int16(answeredCount)
        session.skippedCount = session.totalQuestions - Int16(answeredCount)
        session.scorePercentage = session.totalQuestions > 0
            ? Double(correctCount) / Double(session.totalQuestions) * 100.0
            : 0
        try? context.save()
    }
}
