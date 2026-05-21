import SwiftUI

struct SettingsView: View {
    @State private var showClearDataAlert = false

    var body: some View {
        Form {
            Section("数据管理") {
                Button(role: .destructive) {
                    showClearDataAlert = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("清除所有数据")
                    }
                }
            }

            Section("关于") {
                HStack {
                    Text("应用名称")
                    Spacer()
                    Text(Constants.appName)
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("版本")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("设置")
        .alert("确认清除", isPresented: $showClearDataAlert) {
            Button("取消", role: .cancel) {}
            Button("清除", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("此操作将删除所有导入的PDF、题目数据和练习记录，且不可恢复。")
        }
    }

    private func clearAllData() {
        let context = PersistenceController.shared.container.viewContext
        let entities = ["CDDocument", "CDQuestion", "CDOption", "CDTestSession", "CDUserAnswer", "CDWrongAnswer"]
        for entity in entities {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            _ = try? context.execute(batchDelete)
        }
        try? context.save()
    }
}
