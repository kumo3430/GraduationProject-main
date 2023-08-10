//
//  FireAuth.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

struct FireAuth {
    static let share = FireAuth()
    
    private init() { }
    
    func signinWithGoogle(presenting: UIViewController, completion: @escaping(Error?) -> Void) {
        // 獲取Google的clientID：首先，透過FirebaseApp.app()?.options.clientID獲取Firebase項目的clientID，用於Google Sign-In
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        //創建Google Sign-In配置：使用獲取到的clientID創建一個GIDConfiguration物件，該物件用於Google Sign-In的配置
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        //開始登入流程：使用GIDSignIn.sharedInstance.signIn方法開始Google Sign-In流程。這會彈出一個Google登入視窗供用戶登入，並在登入完成後執行閉包
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { result, error in
            // 處理登入結果：在登入完成的閉包內，首先檢查是否有錯誤發生，如果有錯誤，則通過閉包返回錯誤。否則，繼續處理成功登入的情況
            guard error == nil else {
                completion(error)
                // ...
                return
            }
            // 獲取用戶資訊：從Google登入的結果中獲取用戶資訊，包括用戶的ID Token和Access Token。
            // 疑似從這段就可以獲得id
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//            else {
//                // ...
//                return
//            }
            // yun 改
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                // 條件不滿足時的處理邏輯
                print("無法獲取用戶資訊或idToken為空")
                return
            }

            // 條件滿足時的處理邏輯
            print("idToken: \(idToken)")

            
            
            // 創建Firebase身份驗證憑據：使用獲取到的ID Token和Access Token，創建一個GoogleAuthProvider憑據對象，該對象用於Firebase身份驗證的登入
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // 進行Firebase身份驗證：使用創建的憑據，通過Auth.auth().signIn方法進行Firebase身份驗證的登入。如果成功登入，則將登入狀態設置為true並存儲在UserDefaults中
//            Auth.auth().signIn(with: credential) { result, error in guard error == nil else {
//                completion(error)
//                return
//            }
//                print("SIGN IN")
//                UserDefaults.standard.set(true, forKey: "signIn")
//            }
            // yun 改
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    // 處理登入錯誤
                    completion(error)
                } else {
                    // 登入成功，將登入狀態設置為 true
                    print("SIGN IN")
                    UserDefaults.standard.set(true, forKey: "signIn")
                }
            }

        }
    }
}
