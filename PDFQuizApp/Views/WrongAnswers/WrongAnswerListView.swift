import SwiftUI

struct WrongAnswerListView: View {
    @StateObject private var viewModel = WrongAnswerListViewModel()
    @State private var selectedGrouping = 0

    var body: some View {
        Group {
            if viewModel.wrongAnswers.isEmpty {
                EmptyStateView(
                    icon: "checkmark.circle",
                    title: "暂无错题",
                    message: "练习中答错的题目会自动收集到这里",
                    actionTitle: nil,
                    action: nil
                )
            } else {
                VStack(spacing: 0) {
                    Picker("分组", selection: $selectedGrouping) {
                        Text("按日期").tag(0)
                        Text("按文档").tag(1)
                        Text("按掌握度").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    List {
                        ForEach(viewModel.wrongAnswers) { wrongAnswer in
                            NavigationLink(destination: WrongAnswerDetailView(wrongAnswer: wrongAnswer)) {
                                WrongAnswerRowView(wrongAnswer: wrongAnswer)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteWrongAnswers(at: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
        }
        .navigationTitle("错题记录")
        .toolbar {
            if !viewModel.wrongAnswers.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("复习全部") {
                        WrongAnswerReviewView(wrongAnswers: viewModel.wrongAnswers)
                    }
                }
            }
        }
    }
}
