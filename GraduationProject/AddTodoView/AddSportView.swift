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
    @State private var showSportPicker = false
    @State private var selectedSport = "跑步" // 預設值

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

    let sportUnits = ["小時", "次", "卡路里"]

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
                        
                        Button(action: {
                            self.showSportPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedSport)
                                    .foregroundColor(.black)

                            }
                        }
                        .buttonStyle(.bordered)
                    }

                    if showSportPicker {
                        Picker("運動類型", selection: $selectedSport) {
                            ForEach(sports, id: \.self) { sport in
                                Text(sport).tag(sport)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }


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
//                            let todo = Todo(id: Int(todoData.todo_id)!,
//                                            label: label,
//                                            title: todoTitle,
//                                            description: todoIntroduction,
//                                            startDateTime: startDateTime,
//                                            todoStatus: todoStatus,
//                                            dueDateTime: dueDateTime,
//                                            reminderTime: reminderTime,
//                                            todoNote: todoNote)
//                            todoStore.todos.append(todo)
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
