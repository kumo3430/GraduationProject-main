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

struct UserData: Decodable {
    var todo_id: [String]
    var userId: String?
    var category_id: Int
    var todoTitle: [String]
    var todoIntroduction: [String]
    var startDateTime: [String]
    var reminderTime: [String]
    var repetition1Status: [String?]
    var repetition2Status: [String?]
    var repetition3Status: [String?]
    var repetition4Status: [String?]
    var message: String
}

class TodoStore: ObservableObject {
    @Published var todos = [Todo]()
}


class TaskStore: ObservableObject {
    // 具有一個已發佈的 tasks 屬性，該屬性存儲任務的數組
    @Published var tasks: [Task] = []
    // 根據日期返回相應的任務列表
    func tasksForDate(_ date: Date) -> [Task] {
        //        return tasks
        let filteredTasks = tasks.filter { task in
            return formattedDate(date) == formattedDate(task.nextReviewDate)
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
