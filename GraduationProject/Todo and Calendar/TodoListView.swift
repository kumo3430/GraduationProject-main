//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @AppStorage("uid") private var uid: String = ""
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var hasLoadedData = false
    @State var ReviewChecked0: Bool
    @State var ReviewChecked1: Bool
    @State var ReviewChecked2: Bool
    @State var ReviewChecked3: Bool
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                if taskStore.tasks.isEmpty {
                    // Display the message when there are no tasks
                    Text("尚未新增事項")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)  // Center the message
                } else {
                    List {
                        ForEach(taskStore.tasks.indices, id: \.self) { index in
                            NavigationLink(destination: TaskDetailView(task: $taskStore.tasks[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(taskStore.tasks[index].title)
                                        .font(.headline)
                                    Text(taskStore.tasks[index].description)
                                        .font(.subheadline)
                                    Text("Start time: \(formattedDate(taskStore.tasks[index].nextReviewDate))")
                                        .font(.caption)
                                }
                            }
                        }
                        ForEach(todoStore.todos.indices, id: \.self) { index in
                            NavigationLink(destination: TodoGeneralDetailView(todo: $todoStore.todos[index])) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(todoStore.todos[index].title)
                                        .font(.headline)
                                    Text(todoStore.todos[index].description)
                                        .font(.subheadline)
                                    Text("Start time: \(formattedDate(todoStore.todos[index].startDateTime))")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("待辦事項", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        switchViewAction()  // 切換視圖
                    }) {
                        Image(systemName: "calendar")
                    },
                trailing:
                    Button(action: {
                        self.showingActionSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
            )
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("新增事件"), message: Text("選擇一個事件類型"), buttons: [
                    .default(Text("一般學習"), action: {
                        self.action = .generalLearning
                    }),
                    .default(Text("間隔學習"), action: {
                        self.action = .spacedLearning
                    }),
                    .default(Text("運動"), action: {
                        self.action = .sport
                    }),
                    .default(Text("作息"), action: {
                        self.action = .routine
                    }),
                    .default(Text("飲食"), action: {
                        self.action = .diet
                    }),
                    .cancel()
                ])
            }
            .sheet(item: $action) { item in
                switch item {
                case .generalLearning:
                    AddStudyView()
                case .spacedLearning:
                    AddTaskView()
                case .sport:
                    AddSportView()
                default:
                    AddStudyView()
                }
            }
        }
    }
    
    // 用於將日期格式化為指定的字符串格式
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    
}

struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {})
        //        TodoListView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
    }
}
