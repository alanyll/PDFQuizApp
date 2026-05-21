import SwiftUI
import CoreData
import PDFKit

@MainActor
final class DocumentListViewModel: ObservableObject {
    @Published var documents: [CDDocument] = []
    @Published var importError: String?

    private let context = PersistenceController.shared.container.viewContext

    init() {
        fetchDocuments()
    }

    func fetchDocuments() {
        let request: NSFetchRequest<CDDocument> = CDDocument.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CDDocument.createdAt, ascending: false)
        ]
        do {
            documents = try context.fetch(request)
        } catch {
            importError = "加载文档失败: \(error.localizedDescription)"
        }
    }

    func importPDF(from url: URL) {
        guard url.startAccessingSecurityScopedResource() else {
            importError = "无法访问文件"
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        let fileName = url.lastPathComponent
        let destURL = FileManager.default.uniquePDFURL(for: fileName)

        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: url, to: destURL)

            let document = CDDocument(context: context)
            document.id = UUID()
            document.title = (fileName as NSString).deletingPathExtension
            document.fileName = fileName
            document.relativePath = destURL.lastPathComponent
            document.importStatus = ImportStatus.completed.rawValue
            document.createdAt = Date()

            if let pdf = PDFDocument(url: destURL) {
                document.pageCount = Int16(pdf.pageCount)
            }

            try context.save()
            fetchDocuments()
        } catch {
            importError = "导入失败: \(error.localizedDescription)"
        }
    }

    func deleteDocuments(at offsets: IndexSet) {
        for index in offsets {
            let document = documents[index]
            if let path = document.relativePath {
                let url = FileManager.default.importedPDFsDirectory.appendingPathComponent(path)
                try? FileManager.default.removeItem(at: url)
            }
            context.delete(document)
        }
        try? context.save()
        fetchDocuments()
    }
}
