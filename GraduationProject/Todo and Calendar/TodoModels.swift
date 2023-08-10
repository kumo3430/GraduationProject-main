//
//  TodoModels.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import Foundation

struct Task: Identifiable {
    // 以下是他的屬性
    var id: Int
    var title: String
    var description: String
    var nextReviewDate: Date
    var nextReviewTime: Date
    var isReviewChecked0: Bool
    var isReviewChecked1: Bool
    var isReviewChecked2: Bool
    var isReviewChecked3: Bool
}

struct Todo: Identifiable {
    var id: Int
    var uid: String
    var category_id: Int
    var label: String
    var todoTitle: String
    var todoIntroduction: String
    var startDateTime: Date
    var todoStatus: Bool
    var dueDateTime: Date
    var recurring_task_id: Int?
    var reminderTime: Date
    var todoNote: String
}
