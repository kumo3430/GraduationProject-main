//
//  ChatUser.swift
//  GraduationProject
//
//  Created by heonrim on 5/25/23.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

struct ChatUser: Identifiable {
    
    var id: String { uid }
    
    let uid, email, profileImageUrl: String
    
    init(data: [String: Any]) {
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
    
    static var current: ChatUser? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        let uid = currentUser.uid
        let email = currentUser.email ?? ""
        // 可以根據需要獲取其他使用者資料
        
        let data: [String: Any] = [
            "uid": uid,
            "email": email
            // 添加其他使用者資料字段
        ]
        
        return ChatUser(data: data)
    }
}
