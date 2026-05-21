import Foundation
import CoreData

@MainActor
final class MockExamManager: ObservableObject {
    @Published var remainingSeconds: Int
    @Published var isTimeUp = false

    private var timer: Timer?
    private let totalSeconds: Int
    private let context: NSManagedObjectContext

    init(timeLimitMinutes: Int, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.totalSeconds = timeLimitMinutes * 60
        self.remainingSeconds = timeLimitMinutes * 60
        self.context = context
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.timer?.invalidate()
                    self.isTimeUp = true
                }
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    var elapsedSeconds: Double {
        Double(totalSeconds - remainingSeconds)
    }

    func createExamSession(document: CDDocument?, questionCount: Int) -> CDTestSession {
        let session = CDTestSession(context: context)
        session.id = UUID()
        session.type = TestSessionType.mockExam.rawValue
        session.startedAt = Date()
        session.totalQuestions = Int16(questionCount)
        session.timeLimitSeconds = Int32(totalSeconds)
        session.document = document
        return session
    }

    func completeExam(_ session: CDTestSession, correctCount: Int, incorrectCount: Int, answeredCount: Int) {
        let manager = QuizSessionManager(context: context)
        manager.completeSession(session, correctCount: correctCount, incorrectCount: incorrectCount, answeredCount: answeredCount)
        session.elapsedSeconds = elapsedSeconds
        session.isTimedOut = isTimeUp
        try? context.save()
    }

    deinit {
        timer?.invalidate()
    }
}
