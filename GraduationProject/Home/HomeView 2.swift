//
//  HomeView.swift
//  GraduationProject
//
//  Created by heonrim on 8/3/23.
//

import SwiftUI

struct HomeView: View {
    @State var quote = "精通習慣由重複開始，而非完美。"
    @State var goal = ["Learn English"]
    @State var achievements = ["上個月任務完成度達100%"]
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var todoStore: TodoStore
    // Helper function to format date
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("每日一句")
                            .font(.headline)
                        
                        HStack {
                            Text(quote)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                }
                
                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("今日任務完成度")
                            .font(.headline)
                        
                        HStack {
                            let percentage = Int(0.5 * 100)
                            Text("\(percentage)%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(percentage == 100 ? .blue : .gray)
                            //當今日事件完成度percentage部分會顯示為藍色
                            Spacer()
                            
                            ProgressView(value: 0.5)
                                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        }
                    }
                }
                TodayTodoView()
                
                CardView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("成就")
                            .font(.headline)
                        
                        ForEach(achievements, id: \.self) { achievement in
                            HStack {
                                Text(achievement)
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Image(systemName: "trophy")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                SwipeableCards()
            }
            .padding()
        }
    }
   
    
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskStore())
            .environmentObject(TodoStore())
            .background(Color.gray.opacity(0.1))
    }
}

struct SwipeableCards: View {
    var body: some View {
        TabView {
            ForEach(1...5, id: \.self) { index in
                CardView {
                    VStack {
                        Text("我是來自群組相關最新消息的")
                        Text("Card \(index)")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 250)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
