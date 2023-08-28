//
//  AddDietsView.swift
//  GraduationProject
//
//  Created by heonrim on 8/8/23.
//
import SwiftUI

struct AddDietView: View {
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
    @State var dietsType: String = ""
    @State private var dietsValue: Float = 0.0
    @State private var showDietsPicker = false
    @State private var selectedDiets = "減醣"
    @State private var selectedDietsUnit: String = "次"
    let diets = [
      "減糖", "多喝水", "少油炸", "多吃蔬果"
    ]

    let dietsUnitsByType: [String: [String]] = [
        "減糖": ["次"],
        "多喝水": ["豪升"],
        "少油炸": ["次"],
        "多吃蔬果": ["份"]
    ]

    let dietsPreTextByType: [String: String] = [
        "減糖": "少於",
        "多喝水": "至少",
        "少油炸": "少於",
        "多吃蔬果": "至少"
    ]


    let timeUnits = ["日", "周", "月"]

    @State private var dietsUnit: String = "次"
    @State private var isRecurring = false
    @State private var selectedFrequency = 1
    @State private var recurringOption = 1
    @State private var recurringEndDate = Date()

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

                        Text("飲食類型")

                        Spacer()

                        Button(action: {
                            self.showDietsPicker.toggle()
                        }) {
                            HStack {
                                Text(selectedDiets)
                                    .foregroundColor(.black)

                            }
                        }
                        .buttonStyle(.bordered)
                    }

                    if showDietsPicker {
                        Picker("飲食類型", selection: $selectedDiets) {
                            ForEach(diets, id: \.self) { diets in
                                Text(diets).tag(diets)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }


                    HStack {
                        // Pre-text based on the diet type
                        if let preText = dietsPreTextByType[selectedDiets] {
                            Text(preText)
                                .font(.subheadline) // Reduce font size if necessary
                        }

                        // Numeric Input
                        TextField("數值", value: $dietsValue, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .frame(width: 60, alignment: .leading) // Adjust width
                        
                        // Primary Unit (e.g., 毫升, 次, 份)
                        if let primaryUnits = dietsUnitsByType[selectedDiets] {
                            Text(primaryUnits.first!)
                                .font(.subheadline) // Reduce font size if necessary
                        }

                        Spacer() // Pushes the remaining elements to the right
                        
                        // "/" Symbol
                        Text("/")
                            .padding(.horizontal, 2)

                        // Time Unit (e.g., 日、週、月)
                        Picker("選擇時間單位", selection: $dietsUnit) {
                            ForEach(timeUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 120, alignment: .trailing) // Adjust width
                    }


                    .padding(.horizontal)



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
            .navigationBarTitle("飲食")
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("返回")
                                            .foregroundColor(.blue)
                                                },
                trailing: Button("完成", action: addTodo))
        }
        .onAppear {
            dietsUnit = dietsUnitsByType["減糖"]!.first!
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
struct AddDietView_Previews: PreviewProvider {
    static var previews: some View {
        AddDietView()
    }
}
