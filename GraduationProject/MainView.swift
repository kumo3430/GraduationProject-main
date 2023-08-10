//
//  MainView.swift
//  GraduationProject
//
//  Created by heonrim on 4/24/23.
//

import SwiftUI

struct MainView: View {
    enum ActiveView {
        case calendar, todo
    }
    
    @State private var selectedTab = 0
    @State private var activeView: ActiveView = .calendar
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            
            ZStack {
                if activeView == .calendar {
                    CalendarView(switchViewAction: {
                        activeView = .todo
                    })
                } else {
                    TodoListView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false, switchViewAction: {
                        activeView = .calendar
                    })
                }
            }
            .tabItem {
                Image(systemName: "calendar")
            }
            .tag(0)
            test()
                .tabItem {
                    Image(systemName: "person.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(TaskStore())
    }
}
