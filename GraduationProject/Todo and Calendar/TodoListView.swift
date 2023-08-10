//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

struct TodoListView: View {
    @EnvironmentObject var taskStore: TaskStore
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
            }
            .listStyle(PlainListStyle())
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
                if !hasLoadedData {
                    StudySpaceList()
                    hasLoadedData = true
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
        
        let url = URL(string: "http://localhost:8888/StudySpaceList.php")!
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
                            if let startDate = convertToDate(userData.startDateTime[index]),
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
                                let task = Task(id: taskId!, title: userData.todoTitle[index], description: userData.todoIntroduction[index], nextReviewDate: startDate, nextReviewTime: reminderTime, isReviewChecked0: ReviewChecked0, isReviewChecked1: ReviewChecked1, isReviewChecked2: ReviewChecked2, isReviewChecked3: ReviewChecked3)
                                
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

struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {})
            .environmentObject(TaskStore())
    }
}
