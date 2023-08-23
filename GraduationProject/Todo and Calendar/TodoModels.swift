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
    var label: String
    var title: String
    var description: String
    var nextReviewDate: Date
    var nextReviewTime: Date
    var repetition1Count: Date
    var repetition2Count: Date
    var repetition3Count: Date
    var repetition4Count: Date
    var isReviewChecked0: Bool
    var isReviewChecked1: Bool
    var isReviewChecked2: Bool
    var isReviewChecked3: Bool
}

struct Todo: Identifiable {
    var id: Int
    var label: String
    var title: String
    var description: String
    var startDateTime: Date
    var todoStatus: Bool
    var dueDateTime: Date
    var reminderTime: Date
    var todoNote: String
}

struct Ticker: Identifiable {
    var id: String
//    var ticker_id: String
    var name: String
    var deadline: Date
    var exchage: Date
}
