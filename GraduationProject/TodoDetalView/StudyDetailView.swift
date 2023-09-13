//
//  AddTodoView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import SwiftUI

struct StudyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var todo: Todo
    @EnvironmentObject var todoStore: TodoStore
   
    
    @State var messenge = ""
    @State var isError = false
    
    struct TodoData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var todoNote: String
        var message: String
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(todo.title)
                    Text(todo.description)
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
                        Spacer()
                        TextField("標籤", text: $todo.label)
                            .onChange(of: todo.label) { newValue in
                                todo.label = newValue
                            }
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
                        Text("選擇時間")
                        Spacer()
                        Text(formattedDate(todo.startDateTime))
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
                        DatePicker("提醒時間", selection: $todo.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: todo.reminderTime) { newValue in
                                todo.reminderTime = newValue
                            }
                        
                    }
                }
                
                Section {
                    if todo.isRecurring {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 30, height: 30)
                            Text("重複頻率")
                            Spacer()
                            if (todo.selectedFrequency == 1){
                                Text("每日")
                            } else if (todo.selectedFrequency == 2) {
                                Text("每週")
                            } else if (todo.selectedFrequency == 3) {
                                Text("每月")
                            }
                        }
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 30, height: 30)
                            Text("結束重複")
                            Spacer()
                            if (todo.recurringOption == 1){
                                Text("一直重複")
                            } else if (todo.recurringOption == 2) {
                                Text(formattedDate(todo.dueDateTime))
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .frame(width: 30, height: 30)
                            Spacer()
                            Text("不重複")
                        }
                    }
                }
                TextField("備註", text: $todo.todoNote)
                    .onChange(of: todo.todoNote) { newValue in
                        todo.todoNote = newValue
                    }
            }
            .navigationBarTitle("一般學習修改")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button(action: {
                reviseTodo()
                if todo.label == "" {
                    todo.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
                        })
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
    
    func reviseTodo() {
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
        
        let url = URL(string: "http://127.0.0.1:8888/reviseTask/reviseStudy.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = [
//            "label": todo.label,
//            "todoTitle": todo.wrappedValue.todoTitle,
//            "todoIntroduction": todo.todoIntroduction.wrappedValue,
//            "startDateTime": formattedDate(todo.startDateTime),
            //            "dueDateTime": formattedDate(recurringEndDate),
            "id": todo.id,
            "label": todo.label,
            "reminderTime": formattedTime(todo.reminderTime),
            "todoNote": todo.todoNote
        ]
        
        print("reviseTodo - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseTodo - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseTodo - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                print("我是備註啊啊啊：\(todo.todoNote)")
                do {
                    print("reviseTodo - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User revise Study successfully") {
                        print("============== reviseTodo ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("reviseTodo - userDate:\(todoData)")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.label)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        print("事件備註為：\(todoData.todoNote)")
                        print("reviseTodo - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                       
                        print("============== reviseTodo ==============")
                    }  else {
                        isError = true
                        print("reviseTodo - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("reviseTodo - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}

struct StudyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var todo = Todo(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                               isRecurring: true,
                               recurringOption:2,
                               selectedFrequency: 1,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註")
        StudyDetailView(todo: $todo)
    }
}
