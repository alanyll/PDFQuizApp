import Foundation
import CoreData
import PDFKit

final class PDFImportService {

    func importPDF(from sourceURL: URL, context: NSManagedObjectContext) -> CDDocument? {
        let fileName = sourceURL.lastPathComponent
        let destURL = FileManager.default.uniquePDFURL(for: fileName)

        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)

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
            return document
        } catch {
            print("PDF import failed: \(error)")
            return nil
        }
    }
}
