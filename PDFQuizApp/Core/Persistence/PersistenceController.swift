import CoreData

final class PersistenceController: ObservableObject {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PDFQuizApp")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data store failed: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext

        // Insert sample data for previews
        let doc = CDDocument(context: context)
        doc.id = UUID()
        doc.title = "Sample Exam"
        doc.fileName = "sample_exam.pdf"
        doc.pageCount = 10
        doc.questionCount = 5
        doc.importStatus = "completed"
        doc.createdAt = Date()

        for i in 1...3 {
            let question = CDQuestion(context: context)
            question.id = UUID()
            question.questionText = "Sample question \(i)?"
            question.type = "singleChoice"
            question.pageNumber = Int16(i)
            question.orderIndex = Int16(i)
            question.detectionConfidence = 0.9
            question.correctAnswer = ["A"] as NSObject

            let labels = ["A", "B", "C", "D"]
            for (j, label) in labels.enumerated() {
                let option = CDOption(context: context)
                option.id = UUID()
                option.label = label
                option.text = "Option \(label)"
                option.orderIndex = Int16(j)
                option.question = question
            }
            question.document = doc
        }

        try? context.save()
        return controller
    }()
}
