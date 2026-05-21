import PDFKit

struct ExtractedPage {
    let pageNumber: Int
    let text: String
}

final class PDFTextExtractionService {

    func extractText(from url: URL) -> [ExtractedPage] {
        guard let pdfDocument = PDFDocument(url: url) else { return [] }

        var pages: [ExtractedPage] = []
        for i in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: i) else { continue }
            let rawText = page.string ?? ""
            pages.append(ExtractedPage(
                pageNumber: i + 1,
                text: rawText.strippedHeadersFooters
            ))
        }
        return pages
    }

    func extractText(from document: CDDocument) -> [ExtractedPage] {
        guard let path = document.relativePath else { return [] }
        let url = FileManager.default.importedPDFsDirectory.appendingPathComponent(path)
        return extractText(from: url)
    }
}
