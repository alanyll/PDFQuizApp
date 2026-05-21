import Foundation
import CoreData

@MainActor
final class WrongAnswerManager {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    /// Record a wrong answer. Creates a new CDWrongAnswer or updates an existing one.
    func recordWrongAnswer(for question: CDQuestion) {
        let request: NSFetchRequest<CDWrongAnswer> = CDWrongAnswer.fetchRequest()
        request.predicate = NSPredicate(format: "question == %@", question)
        request.fetchLimit = 1

        if let existing = try? context.fetch(request).first {
            // Update existing record
            existing.wrongCountTotal += 1
            existing.lastWrongDate = Date()
            existing.correctCountSinceLastWrong = 0
            existing.masteryStatus = MasteryStatus.new.rawValue
            existing.reviewIntervalDays = 1
            existing.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        } else {
            // Create new record
            let record = CDWrongAnswer(context: context)
            record.id = UUID()
            record.question = question
            record.wrongCountTotal = 1
            record.firstWrongDate = Date()
            record.lastWrongDate = Date()
            record.masteryStatus = MasteryStatus.new.rawValue
            record.reviewIntervalDays = 1
            record.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        }

        try? context.save()
    }

    /// Update mastery when user answers correctly in review
    func recordCorrectReview(for wrongAnswer: CDWrongAnswer) {
        wrongAnswer.correctCountSinceLastWrong += 1
        wrongAnswer.lastReviewDate = Date()

        // SM-2 simplified spaced repetition
        let intervals = Constants.spacedRepetitionIntervals
        let currentInterval = Int(wrongAnswer.reviewIntervalDays)
        if let currentIdx = intervals.firstIndex(of: currentInterval),
           currentIdx + 1 < intervals.count {
            wrongAnswer.reviewIntervalDays = Int16(intervals[currentIdx + 1])
        } else {
            wrongAnswer.reviewIntervalDays = Int16(intervals.last ?? 120)
        }

        wrongAnswer.nextReviewDate = Calendar.current.date(
            byAdding: .day,
            value: Int(wrongAnswer.reviewIntervalDays),
            to: Date()
        )

        // Update mastery status
        if wrongAnswer.correctCountSinceLastWrong >= Constants.masteryThresholdCorrectCount {
            let currentStatus = MasteryStatus(rawValue: wrongAnswer.masteryStatus ?? "new") ?? .new
            wrongAnswer.masteryStatus = currentStatus.nextStatus.rawValue
        }

        try? context.save()
    }

    /// Get wrong answers due for review
    func getDueForReview() -> [CDWrongAnswer] {
        let request: NSFetchRequest<CDWrongAnswer> = CDWrongAnswer.fetchRequest()
        request.predicate = NSPredicate(format: "nextReviewDate <= %@", Date() as NSDate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CDWrongAnswer.nextReviewDate, ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
}
