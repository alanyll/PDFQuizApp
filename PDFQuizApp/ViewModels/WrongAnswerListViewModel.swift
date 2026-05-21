import SwiftUI
import CoreData

@MainActor
final class WrongAnswerListViewModel: ObservableObject {
    @Published var wrongAnswers: [CDWrongAnswer] = []

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchWrongAnswers()
    }

    func fetchWrongAnswers() {
        let request: NSFetchRequest<CDWrongAnswer> = CDWrongAnswer.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDWrongAnswer.lastWrongDate, ascending: false)
        ]
        do {
            wrongAnswers = try context.fetch(request)
        } catch {
            print("Failed to fetch wrong answers: \(error)")
        }
    }

    func deleteWrongAnswers(at offsets: IndexSet) {
        for index in offsets {
            context.delete(wrongAnswers[index])
        }
        try? context.save()
        fetchWrongAnswers()
    }
}
