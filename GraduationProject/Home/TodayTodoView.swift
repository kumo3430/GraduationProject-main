//
//  TodayTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

extension Task {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self.nextReviewDate)
    }
}

struct TodayTodoView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    
    // Helper function to format date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }

    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack {
                    Text("今日待辦事項")
                        .font(.headline)
                    Spacer()
                }
                
                HStack {
                    Text("間隔學習法")
                        .font(.caption)
                    Spacer()
                }
                
                ForEach(taskStore.tasksForDate(Date()), id: \.id) { task in
                    HStack(alignment: .top) {
                        Text(task.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Group {
                            if formattedDate(Date()) == formattedDate(task.nextReviewDate) {
                                Text("設定日期")
                            } else if formattedDate(Date()) == formattedDate(task.repetition1Count) {
                                Text("第一天")
                            } else if formattedDate(Date()) == formattedDate(task.repetition2Count) {
                                Text("第三天")
                            } else if formattedDate(Date()) == formattedDate(task.repetition3Count) {
                                Text("第七天")
                            } else if formattedDate(Date()) == formattedDate(task.repetition4Count) {
                                Text("第十四天")
                            } else {
                                Text(formattedDate(task.nextReviewDate))
                            }
                        }
                        .font(.caption)
                    }
                }
                
                HStack {
                    Text("一般學習")
                        .font(.caption)
                    Spacer()
                }
                
                ForEach(todoStore.todosForDate(Date()), id: \.id) { todo in
                    HStack(alignment: .top) {
                        Text(todo.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        if formattedDate(Date()) == formattedDate(todo.startDateTime) {
                            Text("設定日期")
                                .font(.caption)
                        } else {
                            Text(formattedDate(todo.startDateTime))
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
}


struct TodayTodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodayTodoView()
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
    }
}
