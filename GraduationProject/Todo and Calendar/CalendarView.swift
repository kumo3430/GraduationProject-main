//
//  CalendarView.swift
//  GraduationProject
//
//  Created by heonrim on 3/27/23.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct CalendarView: View {
    //    @ObservedObject var taskStore = TaskStore()
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var selectedDate = Date()
    @State var showModal = false
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                VStack {
                    datePicker()
                    
                    Divider().frame(height: 1).background(.gray.opacity(0.4))
                    
                    eventList()
                    
                    Spacer()
                }
            }
            .navigationBarTitle("行事曆", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        switchViewAction()  // 切換視圖
                    }) {
                        //                        Image(systemName: "list.pullet")
                        Image(systemName: "list.bullet")
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
            .fullScreenCover(item: $action) { item in
                switch item {
                case .generalLearning:
                    AddTodoView()
                case .spacedLearning:
                    AddTaskView()
                case .sport:
                    AddSportView()
                default:
                    AddTodoView()
                }
            }
            .onAppear() {
                print("taskStore:\(taskStore)")
                print("taskStore.tasks_Calendar:\(taskStore.tasks)")
            }
        }
    }
    
    func datePicker() -> some View {
        DatePicker("Select Date", selection: $selectedDate,
                   in: ...Date.distantFuture, displayedComponents: .date)
        .datePickerStyle(.graphical)
        .onChange(of: selectedDate) { newValue in
            selectedDate = newValue
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func eventList() -> some View {
        let filteredTasks = taskStore.tasksForDate(selectedDate)
        let filteredTodos = todoStore.todosForDate(selectedDate)

        return List {
            Text("間隔學習法")
                .font(.caption)
            ForEach(filteredTasks) { task in
                VStack(alignment: .leading) {
                    if formattedDate(selectedDate) == formattedDate(task.nextReviewDate) {
                        Text(task.title)
                            .font(.headline)
                        Text("設定日期")
                            .font(.subheadline)
                    } else if formattedDate(selectedDate) == formattedDate(task.repetition1Count) {
                        Text(task.title)
                            .font(.headline)
                        Text("第一天")
                            .font(.subheadline)
                    }else if formattedDate(selectedDate) == formattedDate(task.repetition2Count) {
                        Text(task.title)
                            .font(.headline)
                        Text("第三天")
                            .font(.subheadline)
                    }else if formattedDate(selectedDate) == formattedDate(task.repetition3Count) {
                        Text(task.title)
                            .font(.headline)
                        Text("第七天")
                            .font(.subheadline)
                    }else if formattedDate(selectedDate) == formattedDate(task.repetition4Count) {
                        Text(task.title)
                            .font(.headline)
                        Text("第十四天")
                            .font(.subheadline)
                    } else {
                        Text("selectedDate:\(selectedDate)")
                        Text("nextReviewDate:\(task.nextReviewDate)")
                    }
                }
            }
            Text("一般學習")
                .font(.caption)
            ForEach(filteredTodos) { todo in
                VStack(alignment: .leading) {
                    if formattedDate(selectedDate) == formattedDate(todo.startDateTime) {
                        Text(todo.title)
                            .font(.headline)
                        Text("一般學習：設定日期")
                            .font(.subheadline)
                    }  else {
                        Text("selectedDate:\(selectedDate)")
                        Text("startDateTime:\(todo.startDateTime)")
                    }
                }
            }
        }
    }
    
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
    }
}

