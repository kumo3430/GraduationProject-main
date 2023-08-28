//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct AddStudyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoStore: TodoStore

    @State var uid: String = ""
    @State var category_id: Int = 1
    @State var label: String = ""
    @State var todoTitle: String = ""
    @State var todoIntroduction: String = ""
    @State var startDateTime: Date = Date()
    @State var todoStatus: Bool = false
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1  // 1: 持續重複, 2: 選擇結束日期
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false

    struct TodoData : Decodable {
        var userId: String?
        var category_id: Int
        var label: String
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        var todoStatus: Int
        var reminderTime: String
        var dueDateTime: String
        var todo_id: Int
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("標題", text: $todoTitle)
                    TextField("內容", text: $todoIntroduction)
                }
                Section {
                        HStack {
                            Image(systemName: "tag.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                                .foregroundColor(.white) // 圖示顏色設為白色
                                .padding(6) // 確保有足夠的空間顯示外框和背景色
                                .background(Color.yellow) // 設定背景顏色
                                .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                                .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                            TextField("標籤", text: $label)
                        }
                    }
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("選擇時間", selection: $startDateTime, displayedComponents: [.date])
                    }
                    HStack {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        DatePicker("提醒時間", selection: $reminderTime, displayedComponents: [.hourAndMinute])
                    }
                }

                Section {
                    Toggle(isOn: $isRecurring) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 30, height: 30)
                            Text("重複")
                        }
                    }

                    if isRecurring {
                        Picker("重複頻率", selection: $selectedFrequency) {
                            Text("每日").tag(1)
                            Text("每週").tag(2)
                            Text("每月").tag(3)
                        }

                        Picker("結束重複", selection: $recurringOption) {
                            Text("一直重複").tag(1)
                            Text("選擇結束日期").tag(2)
                        }

                        if recurringOption == 2 {
                            DatePicker("結束重複日期", selection: $recurringEndDate, displayedComponents: [.date])
                        }
                    }
                }
                TextField("備註", text: $todoNote)
            }
            .navigationBarTitle("一般學習")
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("返回")
                                            .foregroundColor(.blue)
                                                },
                trailing: Button("完成", action: addTodo))
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    
    func addTodo() {
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
        
        let url = URL(string: "http://127.0.0.1:8888/addStudyGeneral.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        if isRecurring {
//            if recurringOption == 1 {
//                // 如果持續重複
//                let body = [
//                            "label": label,
//                            "todoTitle": todoTitle,
//                            "todoIntroduction": todoIntroduction,
//                            "startDateTime": formattedDate(startDateTime),
//                            // 加入重複週期
//                            "frequency":selectedFrequency,
//                            "dueDateTime": recurringEndDate.addingTimeInterval(60*60*24*365*5),
//                            "reminderTime": formattedTime(reminderTime),
//                            "todoNote": todoNote] as [String : Any]
//            } else {
//                // 如果有截止日期
//                let body = [
//                            "label": label,
//                            "todoTitle": todoTitle,
//                            "todoIntroduction": todoIntroduction,
//                            "startDateTime": formattedDate(startDateTime),
//                            // 加入重複週期
//                            "frequency": selectedFrequency,
//                            // 加入結束時間
//                            "dueDateTime": recurringEndDate,
//                            "reminderTime": formattedTime(reminderTime),
//                            "todoNote": todoNote] as [String : Any]
//            }
//        } else {
//            // 如果有不重複
//            let body = [
//                        "label": label,
//                        "todoTitle": todoTitle,
//                        "todoIntroduction": todoIntroduction,
//                        "startDateTime": formattedDate(startDateTime),
//                        // 加入重複週期
//                        "frequency": 0,
//                        // 加入結束時間
//                        "dueDateTime": recurringEndDate,
//                        "reminderTime": formattedTime(reminderTime),
//                        "todoNote": todoNote] as [String : Any]
//        }
        var body: [String: Any] = [
                "label": label,
                "todoTitle": todoTitle,
                "todoIntroduction": todoIntroduction,
                "startDateTime": formattedDate(startDateTime),
                "dueDateTime": formattedDate(recurringEndDate),
                "reminderTime": formattedTime(reminderTime),
                "todoNote": todoNote
            ]

            if isRecurring {
                body["frequency"] = selectedFrequency
                if recurringOption == 1 {
                    // 持續重複
                    body["dueDateTime"] = formattedDate(recurringEndDate.addingTimeInterval(60 * 60 * 24 * 365 * 5))
                } else {
                    // 選擇結束日期
                    body["dueDateTime"] = formattedDate(recurringEndDate)
                }
            } else {
                // 不重複
                body["frequency"] = 0
                body["dueDateTime"] = formattedDate(recurringEndDate)
            }
       
        print("AddTodoView - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("AddTodoView - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("AddTodoView - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print("AddTodoView - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User New StudyGeneral successfullyUser New first RecurringInstance successfully") {
                        print("============== AddTodoView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addStudySpaced - userDate:\(todoData)")
                        print("使用者ID為：\(todoData.userId ?? "N/A")")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.category_id)")
                        print("事件名稱為：\(todoData.todoTitle)")
                        print("事件簡介為：\(todoData.todoIntroduction)")
                        print("事件種類為：\(todoData.label)")
                        print("事件狀態為：\(todoData.todoStatus)")
                        print("開始時間為：\(todoData.startDateTime)")
                        print("提醒時間為：\(todoData.reminderTime)")
//                        print("截止日期為：\(todoData.dueDateTime)")
                        print("事件編號為：\(todoData.todo_id)")
                        print("AddTodoView - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
//                        DispatchQueue.main.async {
//                            var todo: Todo?
//                            if recurringOption == 2 {
//                                // 有截止日期
//                                todo = Todo(id: Int(todoData.todo_id)!,
//                                                label: label,
//                                                title: todoTitle,
//                                                description: todoIntroduction,
//                                                startDateTime: startDateTime,
//                                                todoStatus: todoStatus,
//                                                dueDateTime: recurringEndDate,
//                                                reminderTime: reminderTime,
//                                                todoNote: todoNote)
//                            } else {
//                                // 沒有截止日期
//                                todo = Todo(id: Int(todoData.todo_id)!,
//                                                label: label,
//                                                title: todoTitle,
//                                                description: todoIntroduction,
//                                                startDateTime: startDateTime,
//                                                todoStatus: todoStatus,
//                                                dueDateTime: recurringEndDate,
//                                                reminderTime: reminderTime,
//                                                todoNote: todoNote)
//                            }
////                            todoStore.todos.append(todo)
////                            presentationMode.wrappedValue.dismiss()
//                            if let unwrappedTodo = todo {  // 使用可選綁定來解封 'todo'
//                                todoStore.todos.append(unwrappedTodo)
//                                presentationMode.wrappedValue.dismiss()
//                            }
//                        }
                        print("============== AddTodoView ==============")
                    } else if (todoData.message == "The Todo is repeated") {
                        isError = true
                        print("AddSpacedView - message：\(todoData.message)")
                        messenge = "已建立過，請重新建立"
                    } else if (todoData.message == "New Todo - Error: <br>Incorrect integer value: '' for column 'uid' at row 1") {
                        isError = true
                        print("AddSpacedView - message：\(todoData.message)")
                        messenge = "登入出錯 請重新登入"
                    } else {
                        isError = true
                        print("AddTodoView - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("AddTodoView - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}

struct AddStudyView_Previews: PreviewProvider {
    static var previews: some View {
        AddStudyView()
            .environmentObject(TodoStore())
    }
}
