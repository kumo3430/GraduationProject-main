import Foundation
import SwiftUI
import FirebaseCore
import Firebase // 添加 Firebase 模塊
import GoogleSignIn

struct TestView: View {
    
    var body: some View {
        
        VStack{
            Text("Hello, World!")
            Button(action: {
                UserDefaults.standard.set(false, forKey: "signIn")
            }, label: {
                Text("登出")
            })
        }
    }
    
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
