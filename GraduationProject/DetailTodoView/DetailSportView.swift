//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct DetailSportView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sportStore: SportStore
    @Binding var sport: Sport

    let sports = [
      "跑步", "單車騎行", "散步", "游泳", "爬樓梯", "健身",
      "瑜伽", "舞蹈", "滑板", "溜冰", "滑雪", "跳繩",
      "高爾夫", "網球", "籃球", "足球", "排球", "棒球",
      "曲棍球", "壁球", "羽毛球", "舉重", "壁球", "劍道",
      "拳擊", "柔道", "跆拳道", "柔術", "舞劍", "團體健身課程"
    ]

    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()
    
    @State var messenge = ""
    @State var isError = false

    let sportUnits = ["小時", "次", "卡路里"]

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
                    Text(sport.title)
                    Text(sport.description)
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
                            TextField("標籤", text: $sport.label)
                                .onChange(of: sport.label) { newValue in
                                    sport.label = newValue
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
                        Text(formattedDate(sport.startDateTime))
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
                        DatePicker("提醒時間", selection: $sport.reminderTime, displayedComponents: [.hourAndMinute])
                            .onChange(of: sport.reminderTime) { newValue in
                                sport.reminderTime = newValue
                            }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(width: 30, height: 30)
                        
                        Text("運動類型")
                        Spacer()
                        Text(sport.selectedSport)
                        Spacer()
                        Text(String(sport.sportValue))
                        Text(sport.sportUnits)
                    }
                }

                Section {
                    if sport.isRecurring {
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
                            if (sport.selectedFrequency == 1){
                                Text("每日")
                            } else if (sport.selectedFrequency == 2) {
                                Text("每週")
                            } else if (sport.selectedFrequency == 3) {
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
                            if (sport.recurringOption == 1){
                                Text("一直重複")
                            } else if (sport.recurringOption == 2) {
                                Text(formattedDate(sport.dueDateTime))
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
                TextField("備註", text: $sport.todoNote)
                    .onChange(of: sport.todoNote) { newValue in
                        sport.todoNote = newValue
                    }
            }
            .navigationBarTitle("運動")
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("返回")
                                            .foregroundColor(.blue)
                                                },
                trailing:  Button(action: {
                reviseSport()
                if sport.label == "" {
                    sport.label = "notSet"
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
    
    func reviseSport() {
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
            "id": sport.id,
            "label": sport.label,
            "reminderTime": formattedTime(sport.reminderTime),
            "todoNote": sport.todoNote
        ]
        
        print("reviseSport - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("reviseSport - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("reviseSport - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print("reviseSport - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User revise Study successfully") {
                        print("============== reviseSport ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addSport - userDate:\(todoData)")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.label)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        print("事件備註為：\(todoData.todoNote)")
                        print("reviseSport - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
                       
                        print("============== reviseSport ==============")
                    } else {
                        isError = true
                        print("reviseSport - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("reviseSport - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
                }
            }
        }
        .resume()
    }
}
struct DetailSportView_Previews: PreviewProvider {
    static var previews: some View {
        @State var sport = Sport(id: 001,
                               label:"我是標籤",
                               title: "英文",
                               description: "背L2單字",
                               startDateTime: Date(),
                                 selectedSport: "溜冰",
                                 sportValue: 1.1,
                                 sportUnits: "次",
                               isRecurring: true,
                               recurringOption:2,
                               selectedFrequency: 1,
                               todoStatus: false,
                               dueDateTime: Date(),
                               reminderTime: Date(),
                               todoNote: "我是備註")
        DetailSportView(sport: $sport)
    }
}
