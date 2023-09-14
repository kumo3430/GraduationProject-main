//
//  QuoteView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

struct QuoteView: View {
    var quote: String = "這裡是一句感人的語錄。"
    var source: String = "感人的來源"
    
    var body: some View {
        ZStack {
            // 背景
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            // 語錄內容
            VStack(spacing: 20) {
                Text(quote)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text("— \(source)")
                    .font(.headline)
                    .italic()
            }
            
            // 喜歡按鈕，可以考慮移至其他位置
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // 喜歡按鈕的動作
                    }) {
                        Image(systemName: "heart")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding()
                }
            }
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}

