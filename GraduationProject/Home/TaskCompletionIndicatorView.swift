import SwiftUI

class TaskCompletionViewModel: ObservableObject {
    // Dummy data for tasks
    var tasks = [TaskInfo(title: "Task 1", date: Date(), completedTasks: 3, totalTasks: 5),
                 TaskInfo(title: "Task 2", date: Date().addingTimeInterval(-86400), completedTasks: 2, totalTasks: 4)]
    
    func completedTasks(for timeFrame: TimeFrame, date: Date) -> Int {
        // Implement your logic to filter tasks based on the selected time frame and date
        // For demo purposes, we just return the total completed tasks
        return tasks.reduce(0) { $0 + $1.completedTasks }
    }
    
    func totalTasks(for timeFrame: TimeFrame, date: Date) -> Int {
        // Implement your logic to filter tasks based on the selected time frame and date
        // For demo purposes, we just return the total tasks
        return tasks.reduce(0) { $0 + $1.totalTasks }
    }
    
    func completionPercentage(for timeFrame: TimeFrame, date: Date) -> Double {
        let completed = completedTasks(for: timeFrame, date: date)
        let total = totalTasks(for: timeFrame, date: date)
        return (total == 0) ? 0 : Double(completed) / Double(total)
    }
    
    func breakdown(for timeFrame: TimeFrame, date: Date) -> [String: Double] {
        // The logic here should filter and aggregate tasks based on the selected date and time frame
        switch timeFrame {
        case .week:
            return ["星期一": 0.5, "星期二": 0.7, "星期三": 0.6, "星期四": 0.8, "星期五": 0.9, "星期六": 0.4, "星期日": 0.3]
        case .month:
            return ["第一週": 0.7, "第二週": 0.8, "第三週": 0.6, "第四週": 0.9]
        case .year:
            return ["一月": 0.8,
                    "二月": 0.7,
                    "三月": 0.9,
                    "四月": 0.6,
                    "五月": 0.7,
                    "六月": 0.8,
                    "七月": 0.9,
                    "八月": 0.8,
                    "九月": 0.7,
                    "十月": 0.6,
                    "十一月": 0.7,
                    "十二月": 0.8]
        }
    }
}

struct TaskInfo {
    var title: String
    var date: Date
    var completedTasks: Int
    var totalTasks: Int
}

enum TimeFrame: String, CaseIterable {
    case week = "週指標"
    case month = "月指標"
    case year = "年指標"
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components)!
    }
    
    func startOfMonth(for date: Date) -> Date {
        let components = self.dateComponents([.year, .month], from: date)
        return self.date(from: components)!
    }
    
    func startOfYear(for date: Date) -> Date {
        let components = self.dateComponents([.year], from: date)
        return self.date(from: components)!
    }
}

struct TaskCompletionIndicatorView: View {
    @State private var selectedTimeFrame: TimeFrame = .week
        @State private var selectedDate: Date = Date()
        @ObservedObject var viewModel: TaskCompletionViewModel = TaskCompletionViewModel()
    
    let orderedWeekdays = ["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"]
    
    var currentKeys: [String] {
        switch selectedTimeFrame {
        case .week:
            return orderedWeekdays
        case .month:
            return ["第一週", "第二週", "第三週", "第四週"]
        case .year:
            return ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        }
    }

    var dateRangeForIndicator: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch selectedTimeFrame {
        case .week:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
            let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
            return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
        case .month:
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: selectedDate))!
            let endOfMonth = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!)!
            return "\(formatter.string(from: startOfMonth)) - \(formatter.string(from: endOfMonth))"
        case .year:
            let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: selectedDate))!
            let endOfYear = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!)!
            return "\(formatter.string(from: startOfYear)) - \(formatter.string(from: endOfYear))"
        }
    }
    
    var body: some View {
            VStack(spacing: 20) {
                Text("任務完成指標")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 20)
                
                Picker("選擇時間指標", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases, id: \.self) { frame in
                        Text(frame.rawValue).tag(frame)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 20)
                
                HStack {
                    Button(action: {
                        switch selectedTimeFrame {
                        case .week:
                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                        case .month:
                            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        case .year:
                            selectedDate = Calendar.current.date(byAdding: .year, value: -1, to: selectedDate) ?? selectedDate
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .padding(.horizontal, 10)
                    }
                    
                    Text(dateRange(for: selectedDate, in: selectedTimeFrame))
                        .font(.headline)
                    
                    Button(action: {
                        switch selectedTimeFrame {
                        case .week:
                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                        case .month:
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        case .year:
                            selectedDate = Calendar.current.date(byAdding: .year, value: 1, to: selectedDate) ?? selectedDate
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .padding(.horizontal, 10)
                    }
                }
            
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 12)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.completionPercentage(for: selectedTimeFrame, date: selectedDate)))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(Angle(degrees: -90))
                
                Text("\(Int(viewModel.completionPercentage(for: selectedTimeFrame, date: selectedDate) * 100))%")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(Color.blue)
            }
            .animation(.easeInOut)
            
                VStack(alignment: .leading, spacing: 15) {
                    let data = viewModel.breakdown(for: selectedTimeFrame, date: selectedDate)

                    ForEach(currentKeys, id: \.self) { key in
                        if let value = data[key] {
                            HStack {
                                Text(key)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                Spacer()
                                ProgressView(value: value)
                                    .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                                    .frame(width: 150, height: 8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                                Text("\(Int(value * 100))%")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.blue.opacity(0.05))
    }
    
    func dateRange(for date: Date, in timeFrame: TimeFrame) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            switch timeFrame {
            case .week:
                let startOfWeek = Calendar.current.startOfWeek(for: date)
                let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
                return "\(formatter.string(from: startOfWeek)) - \(formatter.string(from: endOfWeek))"
            case .month:
                let startOfMonth = Calendar.current.startOfMonth(for: date)
                let endOfMonth = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .month, value: 1, to: startOfMonth)!)!
                return "\(formatter.string(from: startOfMonth)) - \(formatter.string(from: endOfMonth))"
            case .year:
                let startOfYear = Calendar.current.startOfYear(for: date)
                let endOfYear = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(byAdding: .year, value: 1, to: startOfYear)!)!
                return "\(formatter.string(from: startOfYear)) - \(formatter.string(from: endOfYear))"
            }
        }
}

struct TaskCompletionIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCompletionIndicatorView()
    }
}
