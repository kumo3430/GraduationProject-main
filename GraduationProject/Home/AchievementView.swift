//
//  AchievementView.swift
//  GraduationProject
//
//  Created by heonrim on 9/5/23.
//

import SwiftUI

struct Achievement {
    var title: String
    var description: String
    var achieved: Bool
    var imageName: String   
}

extension View {
    func AchievementViewCardStyle() -> some View {
        self.padding(.all, 10)
            .background(RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.5))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            )
    }
}

struct AchievementView: View {
    let achievement: Achievement
    
    var body: some View {
        
        HStack {
            // 成就圖示
            Image(systemName: achievement.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(achievement.achieved ? .blue : .gray)
                .padding(.all, 15)
                .background(achievement.achieved ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                .cornerRadius(15)
            
            // 成就描述
            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(.black) // 更改為黑色以提高對比度
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 成就標記
            Image(systemName: achievement.achieved ? "star.fill" : "star")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(achievement.achieved ? .yellow : .gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .AchievementViewCardStyle()
        .padding(.horizontal)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
 
struct AchievementsPageView: View {
    let achievements: [Achievement] = [
        Achievement(title: "首次之旅", description: "第一次添加習慣", achieved: true, imageName: "plus.circle.fill"),
        Achievement(title: "初試啼聲", description: "完成第一個習慣", achieved: true, imageName: "checkmark.circle.fill"),
        Achievement(title: "連續七天", description: "連續 7 天達成習慣", achieved: false, imageName: "calendar.badge.clock"),
        Achievement(title: "月度達成者", description: "連續 30 天達成習慣", achieved: false, imageName: "calendar"),
        Achievement(title: "習慣大師", description: "連續 100 天達成習慣", achieved: false, imageName: "calendar.badge.exclamationmark"),
        Achievement(title: "習慣探索者", description: "完成 10 個習慣", achieved: true, imageName: "square.stack.3d.up"),
        Achievement(title: "習慣專家", description: "完成 50 個習慣", achieved: false, imageName: "square.stack.3d.up.fill"),
        Achievement(title: "習慣傳說", description: "完成 100 個習慣", achieved: false, imageName: "rosette"),
        Achievement(title: "一日之星", description: "在一天內完成多個習慣", achieved: true, imageName: "sun.max.fill"),
        Achievement(title: "周度冠軍", description: "在一周內完成所有習慣", achieved: true, imageName: "crown.fill"),
        Achievement(title: "月度挑戰者", description: "完成一個特定的月度挑戰", achieved: false, imageName: "calendar.circle"),
        Achievement(title: "年度達人", description: "完成一個特定的年度挑戰", achieved: false, imageName: "calendar.circle.fill"),
        Achievement(title: "社交分享者", description: "在社交功能中分享自己的進度或成就", achieved: false, imageName: "arrowshape.turn.up.right.circle.fill"),
        Achievement(title: "多元探索者", description: "嘗試 5 種不同類型的習慣", achieved: true, imageName: "bag.fill.badge.plus"),
        Achievement(title: "重新啟航", description: "在斷掉一個習慣後重新開始並連續堅持 7 天", achieved: false, imageName: "arrow.clockwise")
    ]

    
    var completedAchievements: [Achievement] {
        achievements.filter { $0.achieved }
    }
    
    var uncompletedAchievements: [Achievement] {
        achievements.filter { !$0.achieved }
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(completedAchievements, id: \.title) { achievement in
                            AchievementView(achievement: achievement)
                        }
                        
                        ForEach(uncompletedAchievements, id: \.title) { achievement in
                            AchievementView(achievement: achievement)
                        }
                    }
                    .padding(.top, 20)
                    .animation(.easeInOut)
                }
                .background(LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom))
                .navigationBarTitle("我的成就", displayMode: .large)
            }
        }
}

struct AchievementsPageView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsPageView()
    }
}
