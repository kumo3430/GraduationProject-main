//
//  ContentView.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI

struct ImageView: View {
    var imageURL: URL
    
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView() // 這裡可以顯示一個加載器
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill) // 将图像填充并保持纵横比
            case .failure:
                Image(systemName: "xmark.circle") // 這裡可以顯示一個錯誤圖標或其他UI
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        ImageView(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/graduationproject-98954.appspot.com/o/%E6%88%AA%E5%9C%96%202023-08-02%20%E4%B8%8B%E5%8D%889.58.54.png?alt=media&token=2d3f5691-19d7-4771-8133-526238477857")!)
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 填充整个视图
            .background(Color.clear) // 设置背景颜色为透明，以便显示图像
            .edgesIgnoringSafeArea(.all) // 忽略安全区域，确保图像填充整个屏幕
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
