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
    
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?

    var body: some View {
        ZStack {
            // 背景色
            LinearGradient(gradient: Gradient(colors: [Color("Color"), Color("Color1"), Color("Color2")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // 語錄內容
            VStack(spacing: 30) {
                Text(quote)
                    .font(.title)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .cardStyle() // 使用 cardStyle 修飾符
                
                Text("— \(source)")
                    .font(.headline)
                    .italic()
                    .foregroundColor(Color.black.opacity(0.7))
            }
            .padding(.vertical, 50)
            
            // 喜歡和分享按鈕
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // 喜歡按鈕的動作
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.8)) // 使用稍高的不透明度
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }
                    .padding(.trailing, 20)
                    
                    Button(action: {
                        self.imageToShare = captureView()
                        self.showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white.opacity(0.8)) // 使用稍高的不透明度
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.2), radius: 5)
                    }
                    .padding(.leading, 20)
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 30)
            }
        }
    }
    
    func captureView() -> UIImage? {
        // Capture the current view as UIImage
        // This method needs to be implemented to capture the view
        nil
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {}
}
