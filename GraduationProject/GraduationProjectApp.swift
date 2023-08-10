//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by heonrim on 5/20/23.
//

import SwiftUI
import FirebaseCore

@main
struct YourApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("uid") private var uid:String = ""
    
    @StateObject var taskStore = TaskStore()
    
    @StateObject var todoStore = TodoStore()
    
    
    var body: some Scene {
        WindowGroup {
            if !isSignIn {
                LoginView()
                    .onAppear() {
                        taskStore.clearTasks()
                        UserDefaults.standard.set("", forKey: "uid")
                    }
                
            } else {
                MainView()
                    .environmentObject(taskStore)
                    .environmentObject(todoStore)
                    .onAppear() {
                        print("AppView-AppStorageUid:\(uid)")
                    }
            }
        }
    }
}
