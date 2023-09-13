//
//  TabBarView.swift
//  GraduationProject
//
//  Created by heonrim on 2023/9/10.
//

import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case home = 0
    case favorite
    case chat
    case profile
    
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .favorite:
            return "Favorite"
        case .chat:
            return "Chat"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .home:
            return "house"
        case .favorite:
            return "calendar"
        case .chat:
            return "person.2.fill"
        case .profile:
            return "person.circle"
        }
    }
}

struct TabBarView: View {
    
    enum ActiveView {
        case calendar, todo
    }
    
    @State private var selectedTab = 0
    @State private var activeView: ActiveView = .calendar
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

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
                .tag(1)

                CommunityProfileView()
                    .tag(2)

                TestView()
                    .tag(3)
            }
            
            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(systemName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(Color(red: 78/255, green: 131/255, blue: 162/255).opacity(0.75))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

extension TabBarView{
    func CustomTabItem(systemName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(systemName:systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(isActive ? .white : .white)
                .frame(width: 25, height: 25)
            Spacer()
        }
        .frame(width: isActive ? .infinity : 70, height: 60)
        .background(isActive ? Color(red: 52/255, green: 96/255, blue: 126/255) : .clear)
        .cornerRadius(30)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .environmentObject(SportStore())
            .environmentObject(TickerStore())
    }
}
