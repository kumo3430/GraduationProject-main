//
//  TodoGeneralDetailView.swift
//  GraduationProject
//
//  Created by 呂沄 on 2023/8/12.
//

import SwiftUI

struct TodoGeneralDetailView: View {
    @Binding var todo: Todo
    //@State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var description = ""
    @State var label = ""
    @State var startDateTime = Date()
    @State var todoStatus:Int = 0
    @State var messenge = ""
    @State var isError = false
    struct reviseUserData : Decodable {
        var userId: String?
        var category_id: Int
        var todoTitle: String
        var todoIntroduction: String
        
        var reminderTime: String
        var todo_id: Int
        
        
        var message: String
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("輸入標題", text: $todo.title)
                        .onChange(of: todo.title) { newValue in
                            todo.title = newValue
                            print("New title : \(todo.title)")
                        }
                    TextField("輸入內容", text: $todo.description)
                        .onChange(of: todo.description) { newValue in
                            todo.description = newValue
                            print("New description : \(todo.description)")
                        }
                }
                Section {
                        HStack {
                            Image(systemName: "tag")
                                .resizable()
                                .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                                .foregroundColor(.white) // 圖示顏色設為白色
                                .padding(6) // 確保有足夠的空間顯示外框和背景色
                                .background(Color.blue) // 設定背景顏色
                                .clipShape(RoundedRectangle(cornerRadius: 8)) // 設定方形的邊框，並稍微圓角
                                .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
                            TextField("標籤", text: $todo.label)
                        }
                    }
                Section(header: Text("提醒時間")) {
                    DatePicker("開始時間", selection: $todo.startDateTime, displayedComponents: [.date])
                        .disabled(true)
                    DatePicker("提醒時間", selection: $todo.reminderTime, displayedComponents: [.hourAndMinute])
                        .onChange(of: todo.reminderTime) { newValue in
                            todo.reminderTime = newValue
                            print("New nextReviewTime : \(todo.reminderTime)")
                        }
                }
                
                //            Text(messenge)
                //                .foregroundColor(.red)
                //                .navigationTitle("任務")
                //                .navigationBarItems(
                //                    trailing: Button("完成", action: reviseStudySpaced)
                //                )
                
                
            }
            .onAppear() {
//                todo.title = todo.title
//                todo.description = todo.description
//                todo.startDateTime = todo.startDateTime
            }
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
    
    
    func reviseStudySpaced() {
        if ( todo.todoStatus ) {
            todoStatus = 1
        } else {
            todoStatus = 0
        }
        
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
        
        let url = URL(string: "http://localhost:8888/reviseStudySpaced.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = ["id":  todo.id,"title": todo.title, "description": todo.description,"nextReviewTime": formattedTime(todo.startDateTime),"todoStatus": todoStatus] as [String : Any]
        //        print("reviseStudySpaced - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseStudySpaced - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseStudySpaced - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    print(String(data: data, encoding: .utf8)!)
                    let userData = try decoder.decode(reviseUserData.self, from: data)
                    if (userData.message == "User revise Todo successfully") {
                        print("============== verifyView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("reviseStudySpaced - userDate:\(userData)")
                        print("使用者ID為：\(userData.userId ?? "N/A")")
                        print("事件id為：\(userData.todo_id)")
                        print("事件種類為：\(userData.category_id)")
                        print("事件名稱為：\(userData.todoTitle)")
                        print("事件簡介為：\(userData.todoIntroduction)")
                        //                        print("開始時間為：\(userData.startDateTime)")
                        print("提醒時間為：\(userData.reminderTime)")
                        print("事件編號為：\(userData.todo_id)")
                        //                        print("第一次間隔重複時間為：\(userData.repetition1Count)")
                        print("reviseStudySpaced - message：\(userData.message)")
                        DispatchQueue.main.async {
                            isError = false
                            // 如果沒有錯才可以關閉視窗並且把此次東西暫存起來
                            //                            task = Task(id: task.id,title: task.title, description: task.description, nextReviewDate: task.nextReviewDate, nextReviewTime: task.nextReviewTime, isReviewChecked0: task.isReviewChecked0, isReviewChecked1:  task.isReviewChecked1, isReviewChecked2: task.isReviewChecked2, isReviewChecked3:  task.isReviewChecked3 )
                            todo = Todo(id: todo.id, label: todo.label,title: todo.title, description: todo.description, startDateTime: todo.startDateTime, todoStatus:  todo.todoStatus, dueDateTime:  todo.dueDateTime, reminderTime:  todo.reminderTime, todoNote:  todo.todoNote )
                            presentationMode.wrappedValue.dismiss()
                        }
                        print("============== verifyView ==============")
                    } else  {
                        isError = true
                        print("reviseStudySpaced - message：\(userData.message)")
                        messenge = "修改失敗，請重新建立"
                    }
                } catch {
                    isError = true
                    print("reviseStudySpaced - 解碼失敗：\(error)")
                    messenge = "修改失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}

struct TodoGeneralDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // 創建一個@State變數
        @State var todo = Todo(id: 000, label: "我是標籤", title: "學習", description: "一般學習", startDateTime: Date(), todoStatus: false, dueDateTime: Date(), reminderTime: Date(), todoNote: "我是備註")
        TodoGeneralDetailView(todo: $todo)
    }
}
