import SwiftUI
import CoreData

@MainActor
final class QuizSessionViewModel: ObservableObject {
    @Published var questions: [CDQuestion] = []
    @Published var currentIndex = 0
    @Published var selectedLabels: Set<String> = []
    @Published var showAnswerResult = false
    @Published var correctCount = 0
    @Published var incorrectCount = 0
    @Published var session: CDTestSession

    private let context = PersistenceController.shared.container.viewContext

    var currentQuestion: CDQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var canSubmit: Bool {
        !selectedLabels.isEmpty
    }

    var isComplete: Bool {
        currentIndex >= questions.count
    }

    init(document: CDDocument, questionCount: Int) {
        let ses = CDTestSession(context: PersistenceController.shared.container.viewContext)
        ses.id = UUID()
        ses.type = TestSessionType.practice.rawValue
        ses.startedAt = Date()
        ses.totalQuestions = Int16(questionCount)
        self.session = ses

        let request: NSFetchRequest<CDQuestion> = CDQuestion.fetchRequest()
        request.predicate = NSPredicate(format: "document == %@", document)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDQuestion.orderIndex, ascending: true)]
        request.fetchLimit = questionCount
        let fetched = (try? context.fetch(request)) ?? []
        self.questions = fetched
    }

    func toggleSelection(_ label: String) {
        guard !showAnswerResult else { return }
        let type = QuestionType(rawValue: currentQuestion?.type ?? "singleChoice") ?? .singleChoice
        if type == .singleChoice || type == .trueFalse {
            selectedLabels = [label]
        } else {
            if selectedLabels.contains(label) {
                selectedLabels.remove(label)
            } else {
                selectedLabels.insert(label)
            }
        }
    }

    func submitAnswer() {
        guard let question = currentQuestion else { return }
        showAnswerResult = true

        let correctLabels = (question.correctAnswer as? [String]) ?? []
        let isCorrect = selectedLabels.sorted() == correctLabels.sorted()

        if isCorrect {
            correctCount += 1
        } else {
            incorrectCount += 1
        }

        let answer = CDUserAnswer(context: context)
        answer.id = UUID()
        answer.selectedAnswer = Array(selectedLabels) as NSObject
        answer.isCorrect = isCorrect
        answer.answeredAt = Date()
        answer.session = session
        answer.question = question
    }

    func advanceToNext() {
        currentIndex += 1
        selectedLabels = []
        showAnswerResult = false

        if isComplete {
            session.completedAt = Date()
            session.answeredQuestions = Int16(currentIndex)
            session.correctCount = Int16(correctCount)
            session.incorrectCount = Int16(incorrectCount)
            session.scorePercentage = session.totalQuestions > 0
                ? Double(correctCount) / Double(session.totalQuestions) * 100.0
                : 0
            try? context.save()
        }
    }
}
