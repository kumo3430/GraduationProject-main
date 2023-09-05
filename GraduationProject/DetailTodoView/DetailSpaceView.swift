//
//  AddSpaceView.swift
//  GraduationProject
//
//  Created by heonrim on 8/6/23.
//

import Foundation
import SwiftUI

struct DetailSpaceView: View {
    @Environment(\.presentationMode) var presentationMode
    //    @ObservedObject var taskStore: TaskStore
    //    @StateObject var taskStore: TaskStore
    @EnvironmentObject var taskStore: TaskStore
    @Binding var task: Task
    @State var nextReviewDate = Date()
    @State var nextReviewTime = Date()
    @State var repetition1Count = Date()
    @State var repetition2Count = Date()
    @State var repetition3Count = Date()
    @State var repetition4Count = Date()
    @State var messenge = ""
    @State var isError = false
    
    struct TodoData : Decodable {
        var todo_id: Int
        var label: String
        var reminderTime: String
        var message: String
    }
    
    //    @State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: nextReviewDate)! }
    }
    
    var body: some View {
        NavigationView {
            Form {
                // 此部分為欄位上面小小的字
                Section {
                    Text(task.title)
                    Text(task.description)
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
                        TextField("標籤", text: $task.label)
                            .onChange(of: task.label) { newValue in
                                task.label = newValue
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
                        Text(formattedDate(task.nextReviewDate))
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
                        DatePicker("提醒時間", selection: $task.nextReviewTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: task.nextReviewTime) { newValue in
                                task.nextReviewTime = newValue
                            }
                    }
                }
                
                Section {
                    ForEach(0..<4) { index in
                        HStack {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
                    }
                }
                if(isError) {
                    Text(messenge)
                        .foregroundColor(.red)
                }
            }
            // 一個隱藏的分隔線
            .listStyle(PlainListStyle())
            .navigationBarTitle("間隔學習")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("返回")
                    .foregroundColor(.blue)
            },
                                trailing: Button(action: {
                reviseSpace()
                if task.label == "" {
                    task.label = "notSet"
                }
            }) {
                Text("完成")
                    .foregroundColor(.blue)
            } )
            
        }
        // 如果 title 為空，按鈕會被禁用，即無法點擊。
        .onDisappear() {
            repetition1Count = nextReviewDates[0]
            repetition2Count = nextReviewDates[1]
            repetition3Count = nextReviewDates[2]
            repetition4Count = nextReviewDates[3]
            
            
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
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func reviseSpace() {
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
        
        let url = URL(string: "http://127.0.0.1:8888/reviseTask/reviseSpace.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = [  "id": task.id,
                      "label": task.label,
                      "reminderTime": formattedTime(task.nextReviewTime) ] as [String : Any]
        print("reviseSpace - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseSpace - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseSpace - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    print("AddSpacedView - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User revise Space successfully") {
                        print("============== AddSpacedView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addStudySpaced - userDate:\(todoData)")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.label)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        isError = false
                        DispatchQueue.main.async {
                            // 如果沒有錯才可以關閉視窗並且把此次東西暫存起來
                            presentationMode.wrappedValue.dismiss()
                        }
                        print("============== AddSpacedView ==============")
                    } else  {
                        isError = true
                        print("AddSpacedView - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"
                    }
                } catch {
                    isError = true
                    print("AddSpacedView - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
            // 測試
            //            guard let data = data else {
            //                print("No data returned from server.")
            //                return
            //            }
            //            if let content = String(data: data, encoding: .utf8) {
            //                print(content)
            //            }
        }
        .resume()
    }
}

struct DetailSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        @State var task = Task(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               nextReviewDate: Date(),
                               nextReviewTime: Date(),
                               repetition1Count: Date(),
                               repetition2Count: Date(),
                               repetition3Count: Date(),
                               repetition4Count: Date(),
                               isReviewChecked0: false,
                               isReviewChecked1: false,
                               isReviewChecked2: false,
                               isReviewChecked3: false)
        DetailSpaceView(task: $task)
    }
}
