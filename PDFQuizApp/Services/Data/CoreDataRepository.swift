import CoreData

@MainActor
final class CoreDataRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }

    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
    }

    func batchInsertQuestions(_ detectedQuestions: [DetectedQuestion], document: CDDocument) throws {
        var orderIndex = (document.questionCount)

        for detected in detectedQuestions {
            let question = CDQuestion(context: context)
            question.id = UUID()
            question.questionText = detected.questionText
            question.type = detected.type.rawValue
            question.pageNumber = Int16(detected.pageNumber)
            question.orderIndex = orderIndex
            question.detectionConfidence = detected.confidence
            question.difficulty = detected.difficulty.rawValue
            question.document = document

            var correctLabels: [String] = []

            for (i, opt) in detected.options.enumerated() {
                let option = CDOption(context: context)
                option.id = UUID()
                option.label = opt.label
                option.text = opt.text
                option.orderIndex = Int16(i)
                option.question = question
            }

            question.correctAnswer = correctLabels as NSObject

            orderIndex += 1
        }

        document.questionCount = orderIndex
        try save()
    }
}
