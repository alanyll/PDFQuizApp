import SwiftUI

struct DocumentListView: View {
    @StateObject private var viewModel = DocumentListViewModel()
    @State private var showFileImporter = false

    var body: some View {
        Group {
            if viewModel.documents.isEmpty {
                EmptyStateView(
                    icon: "doc.text.magnifyingglass",
                    title: "暂无文档",
                    message: "点击右上角 + 导入PDF文件",
                    actionTitle: "导入PDF",
                    action: { showFileImporter = true }
                )
            } else {
                List {
                    ForEach(viewModel.documents) { document in
                        NavigationLink(destination: DocumentDetailView(document: document)) {
                            DocumentRowView(document: document)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteDocuments(at: indexSet)
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("文档")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showFileImporter = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    viewModel.importPDF(from: url)
                }
            case .failure(let error):
                viewModel.importError = error.localizedDescription
            }
        }
        .alert("导入错误", isPresented: .constant(viewModel.importError != nil)) {
            Button("确定") { viewModel.importError = nil }
        } message: {
            Text(viewModel.importError ?? "")
        }
    }
}
