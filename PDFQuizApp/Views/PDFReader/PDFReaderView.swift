import SwiftUI
import PDFKit

struct PDFReaderView: View {
    let document: CDDocument

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            PDFKitView(url: pdfURL)
                .navigationTitle(document.title ?? "PDF")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("完成") { dismiss() }
                    }
                }
        }
    }

    private var pdfURL: URL {
        guard let path = document.relativePath else {
            return FileManager.default.importedPDFsDirectory
        }
        return FileManager.default.importedPDFsDirectory.appendingPathComponent(path)
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageVertical
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
