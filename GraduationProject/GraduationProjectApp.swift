//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("uid") private var uid:String = ""
    
    @StateObject var taskStore = TaskStore()
    @StateObject var todoStore = TodoStore()
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        taskStore.clearTasks()
                        UserDefaults.standard.set("", forKey: "uid")
                    }
                
            } else {
                MainView()
                    .environmentObject(taskStore)
                    .environmentObject(todoStore)
                    .onAppear() {
                        StudySpaceList()
                        print("AppView-AppStorageUid:\(uid)")
                    }
            }
        }
    }
    
    private func StudySpaceList() {
        UserDefaults.standard.synchronize()
        print("SpacedView-Uid:\(uid)")
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        
        let url = URL(string: "http://127.0.0.1:8888/StudySpaceList.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/login.php")!
        //        let url = URL(string: "http://163.17.136.73:443/account/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["uid": uid]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(UserData.self, from: data)
                    if userData.message == "no such account" {
                        print("============== SpecedView ==============")
                        print("SoacedList - userDate:\(userData)")
                        print(userData.message)
                        print("SoacedList顯示有問題")
                        print("============== SpecedView ==============")
                    } else {
                        print("============== SpecedView ==============")
                        print("SoacedList - userDate:\(userData)")
                        print("todoId為：\(userData.todo_id)")
                        print("todoTitle為：\(userData.todoTitle)")
                        print("todoIntroduction為：\(userData.todoIntroduction)")
                        print("startDateTime為：\(userData.startDateTime)")
                        print("reminderTime為：\(userData.reminderTime)")
                        
                        // 先將日期和時間字串轉換成對應的 Date 物件
                        func convertToDate(_ dateString: String) -> Date? {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            return dateFormatter.date(from: dateString)
                        }
                        
                        func convertToTime(_ timeString: String) -> Date? {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            return dateFormatter.date(from: timeString)
                        }
                        
                        for index in userData.todoTitle.indices {
                            let ReviewChecked0: Bool
                            let ReviewChecked1: Bool
                            let ReviewChecked2: Bool
                            let ReviewChecked3: Bool
                            if let startDate = convertToDate(userData.startDateTime[index]),
                               let repetition1Count = convertToDate(userData.repetition1Count[index]),
                               let repetition2Count = convertToDate(userData.repetition2Count[index]),
                               let repetition3Count = convertToDate(userData.repetition3Count[index]),
                               let repetition4Count = convertToDate(userData.repetition4Count[index]),
                               let reminderTime = convertToTime(userData.reminderTime[index]) {
                                
                                if (userData.repetition1Status[index] == "0" ){
                                    ReviewChecked0 = false
                                } else {
                                    ReviewChecked0 = true
                                }
                                if (userData.repetition2Status[index] == "0" ){
                                    ReviewChecked1 = false
                                } else {
                                    ReviewChecked1 = true
                                }
                                if (userData.repetition3Status[index] == "0" ){
                                    ReviewChecked2 = false
                                } else {
                                    ReviewChecked2 = true
                                }
                                if (userData.repetition4Status[index] == "0" ){
                                    ReviewChecked3 = false
                                } else {
                                    ReviewChecked3 = true
                                }
                                let taskId = Int(userData.todo_id[index])
//                                let task = Task(id: taskId!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
//
                                let task = Task(id: taskId!, title: userData.todoTitle[index], description: userData.todoIntroduction[index],label: userData.todoLabel[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                                DispatchQueue.main.async {
                                    taskStore.tasks.append(task)
                                    
                                }
                            } else {
                                print("日期或時間轉換失敗")
                            }
                        }
                        print("============== SpecedView ==============")
                    }
                } catch {
                    print("SoacedList - 解碼失敗：\(error)")
                }
            }
        }
        .resume()
    }
}
