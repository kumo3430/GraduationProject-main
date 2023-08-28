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
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("password") private var password:String = ""
    
    @StateObject var taskStore = TaskStore()
    @StateObject var todoStore = TodoStore()
    @StateObject var tickerStore = TickerStore()
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        taskStore.clearTasks()
                        todoStore.clearTodos()
                        tickerStore.clearTodos()
                        UserDefaults.standard.set("", forKey: "uid")
                        UserDefaults.standard.set("", forKey: "userName")
                        UserDefaults.standard.set("", forKey: "password")
                    }
                
            } else {
                MainView()
                    .environmentObject(taskStore)
                    .environmentObject(todoStore)
                    .environmentObject(tickerStore)
                    .onAppear() {
                        StudySpaceList()
                        print("AppView-AppStorageUid:\(uid)")
                        print("AppView-AppStorageUserName:\(userName)")
                        print("AppView-AppStoragePassword:\(password)")
                    }
            }
        }
    }
    
    private func StudySpaceList() {
        taskStore.clearTasks()
        todoStore.clearTodos()
        UserDefaults.standard.synchronize()
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
                print("StudySpaceList - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(TaskData.self, from: data)
                    if userData.message == "no such account" {
                        print("============== StudySpaceList ==============")
                        print("SoacedList - userDate:\(userData)")
                        print(userData.message)
                        print("StudySpaceList - 顯示有問題")
                        print("============== StudySpaceList ==============")
                    } else {
                        print("============== StudySpaceList ==============")
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
                                let task = Task(id: taskId!,label: userData.todoLabel[index], title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, repetition1Count: repetition1Count, repetition2Count: repetition2Count, repetition3Count: repetition3Count, repetition4Count: repetition4Count, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                                
                                
                                DispatchQueue.main.async {
                                    taskStore.tasks.append(task)
                                    
                                }
                            } else {
                                print("StudySpaceList - 日期或時間轉換失敗")
                            }
                        }
                        print("============== StudySpaceList ==============")
                        StudyGeneralList()
                    }
                } catch {
                    print("StudySpaceList - 解碼失敗：\(error)")
                }
            }
        }
        .resume()
    }
    private func StudyGeneralList() {
        UserDefaults.standard.synchronize()
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
        
        let url = URL(string: "http://127.0.0.1:8888/StudyGeneralList.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/login.php")!
        //        let url = URL(string: "http://163.17.136.73:443/account/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["uid": uid]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("StudyGeneralList - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("StudyGeneralList - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(TodoData.self, from: data)
                    if userData.message == "no such account" {
                        print("============== StudyGeneralList ==============")
                        print("StudyGeneralList - userDate:\(userData)")
                        print(userData.message)
                        print("StudyGeneralList顯示有問題")
                        print("============== StudyGeneralList ==============")
                    } else {
                        print("============== StudyGeneralList ==============")
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
                            var todoStatus: Bool = false
                            if let startDate = convertToDate(userData.startDateTime[index]),
                               let dueDateTime = convertToDate(userData.dueDateTime[index]),
                               let reminderTime = convertToTime(userData.reminderTime[index]) {
                                
                                if (userData.todoStatus[index] == "0" ){
                                    todoStatus = false
                                } else {
                                    todoStatus = true
                                }
                                let taskId = Int(userData.todo_id[index])
                                let todo = Todo(id: taskId!,label: userData.todoLabel[index], title: userData.todoTitle[index], description: userData.todoIntroduction[index], startDateTime: startDate, todoStatus: todoStatus, dueDateTime: dueDateTime, reminderTime: reminderTime, todoNote: userData.todoNote[index])
                                
                                
                                DispatchQueue.main.async {
                                    todoStore.todos.append(todo)
                                    
                                }
                            } else {
                                print("StudyGeneralList - 日期或時間轉換失敗")
                            }
                        }
                        print("============== StudyGeneralList ==============")
                        TickerList()
                    }
                } catch {
                    print("StudyGeneralList - 解碼失敗：\(error)")
                }
            }
        }
        .resume()
    }
    
    private func TickerList() {
        UserDefaults.standard.synchronize()
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
        
        let url = URL(string: "http://127.0.0.1:8888/tickersList.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/login.php")!
        //        let url = URL(string: "http://163.17.136.73:443/account/ickersList.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
            let body: [String] = []
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("TickerList - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("TickerList - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(TickerData.self, from: data)
                    if userData.message == "no such account" {
                        print("============== TickerList ==============")
                        print("SoacedList - userDate:\(userData)")
                        print(userData.message)
                        print("StudySpaceList - 顯示有問題")
                        print("============== TickerList ==============")
                    } else {
                        print("============== TickerList ==============")
                        print("TickerList-userDate:\(userData)")
                        print("todoId為：\(userData.ticker_id)")
                        print("tickerTitle為：\(userData.name)")
                        print("deadline為：\(userData.deadline)")
                        print("exchange為：\(userData.exchange)")
                        
                        // 先將日期和時間字串轉換成對應的 Date 物件
                        func convertToDate(_ dateString: String) -> Date? {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            return dateFormatter.date(from: dateString)
                        }
                        
                        func convertToTime(_ timeString: String) -> Date? {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "HH:mm:ss"
                            return dateFormatter.date(from: timeString)
                        }
            
                        for index in userData.ticker_id.indices {
                            if let deadline = convertToDate(userData.deadline[index]) {
                                //var exchange: Date?  // 聲明 exchange 變數
                                var exchange: String?
                                if userData.exchange[index] == nil {
                                    //exchange = nil  // 不需要賦值，因為 exchange 變數已經初始化為 nil
                                    exchange = "尚未兌換"
                                } else {
                                    exchange = (userData.exchange[index]!)
                                }
                                let taskId = userData.ticker_id[index]
                                let task = Ticker(id: taskId, name: userData.name[index], deadline: deadline, exchage: exchange!)
                                
                                DispatchQueue.main.async {
                                    tickerStore.tickers.append(task)
                                }
                            } else {
                                print("TickerList - 尚未兌換")
                            }
                        }

                        print("============== TickerList ==============")
                    }
                } catch {
                    print("TickerList - 解碼失敗：\(error)")
                }
                print("TICKER:\(tickerStore)")
                print("TICKERstore:\(TickerStore())")
            }
        }
        .resume()
    }
}
