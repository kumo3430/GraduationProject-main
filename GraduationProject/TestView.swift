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

struct PostData: Encodable {
    var userID: String
    var Password: String
}

struct TickerRow: View {
    var ticker: Ticker
    @AppStorage("userName") private var userName:String = ""
    @AppStorage("password") private var password:String = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("名稱: \(ticker.name)")
                Text("截止日期: \(formatDate(ticker.deadline))")
                Text("兌換時間: \(ticker.exchage)")
            }
            Spacer()
            Button(action: {
                postTicker()
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
    
    private func postTicker() {
        UserDefaults.standard.synchronize()
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        print("Ticker-userName2:\(userName)")
        print("Ticker-password2:\(password)")
//        print("Ticker-userName2:\(appSettings.userName)")
//        print("Ticker-password2:\(appSettings.password)")
        let url = URL(string: "http://163.17.136.73/api/values/post")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/login.php")!
        //        let url = URL(string: "http://163.17.136.73:443/account/login.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = ["userID": userName,"Password": password]
//        print("body:\(body)")
//        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        let body = PostData(userID: userName, Password: password)
        let jsonData = try! JSONEncoder().encode(body)
        request.httpBody = jsonData
        print("body:\(body)")
        print("jsonData:\(jsonData)")
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("StudySpaceList - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("StudySpaceList - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8)!)
            }
        }
        .resume()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(TickerStore())
    }
}
