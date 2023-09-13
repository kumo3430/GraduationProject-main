//
//  CalendarView.swift
//  GraduationProject
//
//  Created by heonrim on 3/27/23.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct CalendarView: View {
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    @EnvironmentObject var sportStore: SportStore
    @State private var showingActionSheet = false
    @State private var action: Action? = nil
    @State var selectedDate = Date()
    @State var showModal = false
    @State var frequency:Int = 0
    
    var switchViewAction: () -> Void
    
    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                VStack {
                    datePicker().padding(.bottom, 20)
                    
                    ScrollView {
                        eventList()
                    }
                    .padding(.top, 15)
                }
                .padding()
            }
            .navigationBarTitle("行事曆", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        switchViewAction()
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    },
                trailing:
                    Button(action: {
                        self.showingActionSheet = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
            )
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("新增事件"), message: Text("選擇一個事件類型"), buttons: [
                    .default(Text("一般學習"), action: {
                        self.action = .generalLearning
                    }),
                    .default(Text("間隔學習"), action: {
                        self.action = .spacedLearning
                    }),
                    .default(Text("運動"), action: {
                        self.action = .sport
                    }),
                    .default(Text("作息"), action: {
                        self.action = .routine
                    }),
                    .default(Text("飲食"), action: {
                        self.action = .diet
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(item: $action) { item in
                switch item {
                case .generalLearning:
                    AddStudyView()
                case .spacedLearning:
                    AddSpaceView()
                case .sport:
                    AddSportView()
                case .diet:
                    AddDietView()
                default:
                    AddDietView()
                }
            }
        }
    }
    
    func datePicker() -> some View {
        VStack(spacing: 10) {
            Text("選擇日期")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(Color.black.opacity(0.7))
            
            DatePicker("", selection: $selectedDate, in: ...Date.distantFuture, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                )
        }
        .padding(.horizontal, 15)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }

    func eventList() -> some View {
        let filteredTasks = taskStore.tasksForDate(selectedDate)
        let filteredTodos = todoStore.todosForDate(selectedDate)
        let filteredSports = sportStore.sportsForDate(selectedDate)
        
        return VStack(spacing: 20) {
            Group {
                Text("間隔學習法")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredTasks) { task in
                    ModernEventRow(eventTitle: task.title, eventSubtitle: "設定日期: \(formattedDate(task.nextReviewDate))", icon: "calendar")
                }
            }

            Group {
                Text("一般學習")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredTodos) { todo in
                    ModernEventRow(eventTitle: todo.title, eventSubtitle: "開始時間: \(formattedDate(todo.startDateTime))", icon: "book")
                }
            }

            Group {
                Text("運動")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ForEach(filteredSports) { sport in
                    ModernEventRow(eventTitle: sport.title, eventSubtitle: "開始時間: \(formattedDate(sport.startDateTime))", icon: "figure.walk")
                }
            }
        }
        .padding(.horizontal, 15)
    }

    struct ModernEventRow: View {
        var eventTitle: String
        var eventSubtitle: String
        var icon: String
        
        var body: some View {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.blue.opacity(0.7))
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 5) {
                    Text(eventTitle)
                        .font(.headline)
                    Text(eventSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
    
    struct EventRow: View {
        var eventTitle: String
        var eventSubtitle: String
        var icon: String
        
        var body: some View {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color.blue.opacity(0.7))
                VStack(alignment: .leading, spacing: 5) {
                    Text(eventTitle)
                        .font(.headline)
                    Text(eventSubtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(switchViewAction: {})
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
    }
}
