//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var todoStore: TodoStore

    @State var uid: String = ""
    @State var category_id: Int = 1
    @State var label: String = ""
    @State var todoTitle: String = ""
    @State var todoIntroduction: String = ""
    @State var startDateTime: Date = Date()
    @State var todoStatus: Bool = false
    @State var dueDateTime: Date = Date()
//    @State var recurring_task_id: Int? = nil
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
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
        var todo_id: String
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("標題").textCase(nil)) {
                    TextField("輸入標題", text: $todoTitle)
                }
                Section(header: Text("內容").textCase(nil)) {
                    TextField("輸入內容", text: $todoIntroduction)
                }
                Section(header: Text("標籤").textCase(nil)) {
                    TextField("標籤", text: $label)
                }
                Section(header: Text("開始時間").textCase(nil)) {
                    DatePicker("選擇時間", selection: $startDateTime, displayedComponents: [.date])
                    DatePicker("提醒時間", selection: $reminderTime, displayedComponents: [.hourAndMinute])
                }
                TextField("備註", text: $todoNote)
                if(isError) {
                    Text(messenge)
                        .foregroundColor(.red)
                }
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
        let body = [
                    "label": label,
                    "todoTitle": todoTitle,
                    "todoIntroduction": todoIntroduction,
                    "startDateTime": formattedDate(startDateTime),
//                    "todoStatus": todoStatus,
                    "dueDateTime": formattedDate(dueDateTime),
//                    "recurring_task_id": recurring_task_id ?? "",
                    "reminderTime": formattedTime(reminderTime),
                    "todoNote": todoNote] as [String : Any]
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
                    if (todoData.message == "User New StudyGeneral successfully") {
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
                        print("截止日期為：\(todoData.dueDateTime)")
                        print("事件編號為：\(todoData.todo_id)")
                        print("AddTodoView - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            let todo = Todo(id: Int(todoData.todo_id)!,
                                            label: label,
                                            title: todoTitle,
                                            description: todoIntroduction,
                                            startDateTime: startDateTime,
                                            todoStatus: todoStatus,
                                            dueDateTime: dueDateTime,
                                            reminderTime: reminderTime,
                                            todoNote: todoNote)
                            todoStore.todos.append(todo)
                            presentationMode.wrappedValue.dismiss()
                        }
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

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView()
            .environmentObject(TodoStore())
    }
}
