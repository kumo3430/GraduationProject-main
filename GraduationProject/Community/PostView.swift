//
//  PostView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

struct PostView: View {
    @State private var likes = 123
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image("user_avatar") // 您應該替換為用戶的頭像圖片名稱
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Username")
                        .font(.headline)
                    Text("@handle")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text("This is the content of the tweet. Here's where you'll see the tweet's text.")
                .font(.body)
            
            HStack(spacing: 20) {
                
                Button(action: {
                    self.isLiked.toggle()
                    if self.isLiked {
                        self.likes += 1
                    } else {
                        self.likes -= 1
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .frame(width: 20, height: 20)
                        .foregroundColor(isLiked ? .red : .gray)
                }
                
                Text("\(likes)")
                    .font(.subheadline)
                
                Button(action: {
                    // Share action
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 20, height: 20)
                }
                
                Button(action: {
                    // Reply action
                }) {
                    Image(systemName: "bubble.left")
                        .frame(width: 20, height: 20)
                }
            }
            .font(.system(size: 20))
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 10)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
            .previewLayout(.sizeThatFits)
    }
}
