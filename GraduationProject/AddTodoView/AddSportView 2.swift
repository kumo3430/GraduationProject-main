//
//  AddSportView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//

import SwiftUI

struct AddSportView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sportStore: SportStore

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
    @State private var SportUnit: Int = 0
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
    
    @State var messenge = ""
    @State var isError = false

    let sportUnits = ["小時", "次", "卡路里"]

    struct TodoData : Decodable {
        var userId: String?
        var category_id: Int
        var label: String?
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        
        var sportType: String
        var sportValue: Float
        var sportUnit: Int
        
        var todoStatus: Int
        var reminderTime: String
        var dueDateTime: String
        var todo_id: Int
        var todoNote: String?
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
                trailing: Button("完成", action: addSport)
                .disabled(todoTitle.isEmpty && todoIntroduction.isEmpty))
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
    
    func addSport() {
        if sportUnit == "小時" {
            SportUnit = 0
        } else if sportUnit == "次" {
            SportUnit = 1
        } else if sportUnit == "卡路里" {
            SportUnit = 2
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
        
        let url = URL(string: "http://127.0.0.1:8888/addTask/addSport.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var body: [String: Any] = [
            "label": label,
            "todoTitle": todoTitle,
            "todoIntroduction": todoIntroduction,
            "startDateTime": formattedDate(startDateTime),
            "sportType": selectedSport,
            "sportValue": sportValue,
            "SportUnit": SportUnit,
            "reminderTime": formattedTime(reminderTime),
            "todoNote": todoNote
        ]
        
        if isRecurring {
            body["frequency"] = selectedFrequency
            if recurringOption == 1 {
                // 持續重複
                body["dueDateTime"] = formattedDate(Calendar.current.date(byAdding: .year, value: 5, to: recurringEndDate)!)
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
                print("addSport - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("addSport - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    print("addSport - Data : \(String(data: data, encoding: .utf8)!)")
                    let todoData = try decoder.decode(TodoData.self, from: data)
                    if (todoData.message == "User New Sport successfullyUser New first RecurringInstance successfully" || todoData.message == "User New Sport successfully") {
                        print("============== addSport ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("addSport - userDate:\(todoData)")
                        print("使用者ID為：\(todoData.userId ?? "N/A")")
                        print("事件id為：\(todoData.todo_id)")
                        print("事件種類為：\(todoData.category_id)")
                        print("事件名稱為：\(todoData.todoTitle)")
                        print("事件簡介為：\(todoData.todoIntroduction)")
                        print("事件種類為：\(todoData.label ?? "N/A")")
                        print("事件狀態為：\(todoData.todoStatus)")
                        print("開始時間為：\(todoData.startDateTime)")
                        print("運動種類為：\(todoData.sportType)")
                        print("運動目標量為：\(todoData.sportValue)")
                        print("運動目標單位為：\(todoData.sportUnit)")
                        print("提醒時間為：\(todoData.reminderTime)")
                        print("截止日期為：\(todoData.dueDateTime)")
                        print("事件備註：\(todoData.todoNote ?? "N/A")")
                        print("事件編號為：\(todoData.todo_id)")
                        print("addSport - message：\(todoData.message)")
                        isError = false
                        DispatchQueue.main.async {
                            var sport: Sport?
                            sport = Sport(id: Int(exactly: todoData.todo_id)!,
                                        label: label,
                                        title: todoTitle,
                                        description: todoIntroduction,
                                        startDateTime: startDateTime,
                                        selectedSport: selectedSport,
                                        sportValue: sportValue,
                                        sportUnits: sportUnit,
                                        isRecurring: isRecurring,
                                        recurringOption: recurringOption,
                                        selectedFrequency: selectedFrequency,
                                        todoStatus: todoStatus,
                                        dueDateTime: recurringEndDate,
                                        reminderTime: reminderTime,
                                        todoNote: todoNote)
                            if let unwrappedTodo = sport {  // 使用可選綁定來解封 'todo'
                                sportStore.sports.append(unwrappedTodo)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        print("============== addSport ==============")
                    } else {
                        isError = true
                        print("addSport - message：\(todoData.message)")
                        messenge = "建立失敗，請重新建立"                    }
                } catch {
                    isError = true
                    print("addSport - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
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
