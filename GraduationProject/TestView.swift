import Foundation
import SwiftUI
import FirebaseCore
import Firebase // 添加 Firebase 模塊
import GoogleSignIn

struct TestView: View {
    @EnvironmentObject var tickerStore: TickerStore
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
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
        }
      
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
