import Foundation
import SwiftUI
import FirebaseCore
import Firebase // 添加 Firebase 模塊
import GoogleSignIn
import SafariServices

struct TestView: View {
    @EnvironmentObject var tickerStore: TickerStore
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    UserDefaults.standard.set(false, forKey: "signIn")
                }, label: {
                    Text("登出")
                })
                
                Link(destination: URL(string: "http://163.17.136.73/web_login.aspx")!) {
                    Image(systemName: "safari")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                }
                
                List {
                    ForEach(tickerStore.tickers) { ticker in
                        TickerRow(ticker: ticker)
                    }
                }
            }
            
        }
    }
}

struct TickerRow: View {
    var ticker: Ticker
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Name: \(ticker.name)")
                Text("Deadline: \(formatDate(ticker.deadline))")
                Text("Exchange: \(ticker.exchage))")
            }
            Spacer()
            Button(action: {
//                UserDefaults.standard.set(false, forKey: "signIn")
            }, label: {
                Image(systemName: "gift.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 保持圖示的原始寬高比
                    .frame(width: 30, height: 30) // 這裡的尺寸是示例，您可以根據需要調整
//                    .alignmentGuide(.trailing, computeValue: { dimensions in
//
//                    })
            })
        }
        
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(TickerStore())
    }
}
