//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct AddSportView: View {
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
    @State var recurring_task_id: Int? = nil
    @State var reminderTime: Date = Date()
    @State var todoNote: String = ""
    @State var sportType: String = ""
    @State private var sportValue: Float = 0.0
    @State private var sportUnit: String = "次"

    let sportUnits = ["小時", "次"]

    struct TodoData: Decodable {
        var userId: String?
        var category_id: Int
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        var reminderTime: String
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
                Section(header: Text("運動設定").textCase(nil)) {
                    TextField("輸入運動類型", text: $sportType)
                    
                    HStack {
                        TextField("輸入數值", value: $sportValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                        Picker("選擇單位", selection: $sportUnit) {
                            ForEach(sportUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 150, alignment: .trailing)
                    }
                }
                TextField("備註", text: $todoNote)
            }
            .navigationBarTitle("運動")
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
        
        let url = URL(string: "http://localhost:8888/addTodo.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = ["category_id": category_id,
                    "label": label,
                    "todoTitle": todoTitle,
                    "todoIntroduction": todoIntroduction,
                    "startDateTime": formattedDate(startDateTime),
                    "todoStatus": todoStatus,
                    "dueDateTime": formattedDate(dueDateTime),
                    "recurring_task_id": recurring_task_id ?? "",
                    "reminderTime": formattedTime(reminderTime),
                    "todoNote": todoNote] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("addTodo - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("addTodo - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User New Todo successfully") {
                        DispatchQueue.main.async {
                            let todo = Todo(id: Int(todoData.todo_id)!,
//                                            uid: todoData.userId!,
                                            title: todoTitle,
                                            category_id: category_id,
                                            label: label,
                                            todoTitle: todoTitle,
                                            todoIntroduction: todoIntroduction,
                                            startDateTime: startDateTime,
                                            todoStatus: todoStatus,
                                            dueDateTime: dueDateTime,
//                                            recurring_task_id: recurring_task_id,
                                            reminderTime: reminderTime,
                                            todoNote: todoNote)
                            todoStore.todos.append(todo)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("addTodo - message：\(todoData.message)")
                        // handle other messages from the server
                    }
                } catch {
                    print("addTodo - 解碼失敗：\(error)")
                }
            }
        }
        .resume()
    }
}
struct AddSportView_Previews: PreviewProvider {
    static var previews: some View {
        AddSportView()
    }
}
