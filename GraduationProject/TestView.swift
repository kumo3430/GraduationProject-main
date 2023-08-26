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
                HStack {
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
                    
                    Button(action: {
                        // 在此處處理按下按鈕後的動作
                        openSafariView()
                    }, label: {
                        Image(systemName: "safari")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    })
                }
               
                
                List {
                    ForEach(tickerStore.tickers) { ticker in
                        TickerRow(ticker: ticker)
                    }
                }
            }
            
        }
    }
    
    func openSafariView() {
        tickerStore.clearTodos()
        // 設定要開啟的網址
        guard let url = URL(string: "http://163.17.136.73/web_login.aspx") else { return }
        
        // 建立 SFSafariViewController 實例
        let safariViewController = SFSafariViewController(url: url)
        
        // 取得目前的 UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // 取得目前的 UIWindow
            if let mainWindow = windowScene.windows.first {
                // 以全屏方式彈出 SFSafariViewController
                mainWindow.rootViewController?.present(safariViewController, animated: true, completion: nil)
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
