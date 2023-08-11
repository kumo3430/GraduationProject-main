//
//  TodoManager.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import Foundation

enum Action: Int, Identifiable {
    var id: Int { rawValue }
    
    case generalLearning = 1
    case spacedLearning
    case sport
    case routine
    case diet
}

//struct UserData: Decodable {
//    var todo_id: [String]
//    var userId: String?
//    var category_id: Int
//    var todoTitle: [String]
//    var todoIntroduction: [String]
//    var startDateTime: [String]
//    var reminderTime: [String]
//    var repetition1Status: [String?]
//    var repetition2Status: [String?]
//    var repetition3Status: [String?]
//    var repetition4Status: [String?]
//    var message: String
//}
struct UserData: Decodable {
    var todo_id: [String]
    var userId: String?
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var todoLabel: [String]
    var startDateTime: [String]
    var reminderTime: [String]
    var repetition1Status: [String?]
    var repetition2Status: [String?]
    var repetition3Status: [String?]
    var repetition4Status: [String?]
    var repetition1Count: [String]
    var repetition2Count: [String]
    var repetition3Count: [String]
    var repetition4Count: [String]
    var message: String
}

class TodoStore: ObservableObject {
    //    @Published var todos = [Todo]()
    @Published var todos: [Todo] = []
    
    func todosForDate(_ date: Date) -> [Todo] {
        let formattedSelectedDate = formattedDate(date)
        let filteredTodos = todos.filter { todo in
            print("123")
            print("QQQ\(formattedDate(todo.startDateTime))")
            return formattedSelectedDate == formattedDate(todo.startDateTime)
        }
        return filteredTodos
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTasks() {
        todos = []
    }
}


class TaskStore: ObservableObject {
    // 具有一個已發佈的 tasks 屬性，該屬性存儲任務的數組
    @Published var tasks: [Task] = []
    // 根據日期返回相應的任務列表
    func tasksForDate(_ date: Date) -> [Task] {
        let formattedSelectedDate = formattedDate(date)
        let filteredTasks = tasks.filter { task in
            return formattedSelectedDate == formattedDate(task.nextReviewDate) ||
            formattedSelectedDate == formattedDate(task.repetition1Count) ||
            formattedSelectedDate == formattedDate(task.repetition2Count) ||
            formattedSelectedDate == formattedDate(task.repetition3Count) ||
            formattedSelectedDate == formattedDate(task.repetition4Count)
        }
        return filteredTasks
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func clearTasks() {
        tasks = []
    }
}
