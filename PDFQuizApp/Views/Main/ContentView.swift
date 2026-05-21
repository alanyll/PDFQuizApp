import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DocumentListView()
            }
            .tabItem {
                Label("文档", systemImage: "doc.text")
            }
            .tag(0)

            NavigationStack {
                WrongAnswerListView()
            }
            .tabItem {
                Label("错题", systemImage: "xmark.circle")
            }
            .tag(1)

            NavigationStack {
                MockExamConfigView()
            }
            .tabItem {
                Label("模考", systemImage: "timer")
            }
            .tag(2)

            NavigationStack {
                StatisticsView()
            }
            .tabItem {
                Label("进度", systemImage: "chart.bar")
            }
            .tag(3)
        }
        .tint(.appPrimary)
    }
}
