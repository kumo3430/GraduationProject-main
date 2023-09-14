//
//  CommunityProfileView.swift
//  GraduationProject
//
//  Created by heonrim on 8/17/23.
//

import SwiftUI

struct CommunityProfileView: View {
    @State private var selectedTab = 0
    let tabs = ["公告", "貼文", "成員名單", "待"]
    @State private var scrollOffset: CGFloat = 0.0
    @State private var headerHeight: CGFloat = 0.0
    
    var body: some View {
        NavigationView {
            VStack {
                if scrollOffset < headerHeight {
                    ProfileHeader()
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
                        })
                }
                
                Picker("", selection: $selectedTab) {
                    ForEach(0..<tabs.count) { index in
                        Text(self.tabs[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .background(Color.white)
                .offset(y: -min(headerHeight, scrollOffset))
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(1...50, id: \.self) { _ in
                            PostView()
                        }
                    }
                    .padding(.top)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
                    })
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ViewOffsetKey.self) { self.scrollOffset = $0 }
                .onPreferenceChange(ViewHeightKey.self) { self.headerHeight = $0 }
            }
            .navigationBarTitle("社群名稱", displayMode: .inline)
        }
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct ProfileHeader: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("profile_picture")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(radius: 10)
                .padding(.top)
            
            Text("社群名稱")
                .font(.title)
                .bold()
            
            Text("社群簡介")
                .padding(.top, 8)
            
            HStack(spacing: 40) {
                VStack {
                    Text("成員數")
                        .font(.subheadline)
                    Text("890")
                        .font(.headline)
                }
            }
            .padding(.top, 16)
        }
        .padding()
    }
}

struct PostsListView: View {
    var body: some View {
        List {
            ForEach(1...10, id: \.self) { _ in
                PostView()
            }
        }
    }
}

struct CommunityProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityProfileView()
    }
}

// ... 其他未更改的部分 ...

////
////  CommunityProfileView.swift
////  GraduationProject
////
////  Created by heonrim on 8/17/23.
////
//
//import SwiftUI
//import FirebaseStorage
//import FirebaseFirestore
//
//struct CommunityProfileView: View {
//    @State private var selectedTab = 0
//    let tabs = ["貼文", "回覆", "媒體", "喜歡的內容"]
//    @State private var scrollOffset: CGFloat = 0.0
//    @State private var headerHeight: CGFloat = 0.0
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if scrollOffset < headerHeight {
//                    ProfileHeader()
//                        .background(GeometryReader { proxy in
//                            Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
//                        })
//                }
//
//                Picker("", selection: $selectedTab) {
//                    ForEach(0..<tabs.count) { index in
//                        Text(self.tabs[index]).tag(index)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding(.horizontal)
//                .background(Color.white)
//                .offset(y: -min(headerHeight, scrollOffset))
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 15) {
//                        ForEach(1...50, id: \.self) { _ in
//                            PostView()
//                        }
//                    }
//                    .padding(.top)
//                    .background(GeometryReader {
//                        Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .named("scroll")).origin.y)
//                    })
//                }
//                .coordinateSpace(name: "scroll")
//                .onPreferenceChange(ViewOffsetKey.self) { self.scrollOffset = $0 }
//                .onPreferenceChange(ViewHeightKey.self) { self.headerHeight = $0 }
//            }
//            .navigationBarTitle("社群名稱", displayMode: .inline)
//        }
//    }
//}
//
//struct ViewOffsetKey: PreferenceKey {
//    typealias Value = CGFloat
//    static var defaultValue = CGFloat.zero
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value += nextValue()
//    }
//}
//
//struct ViewHeightKey: PreferenceKey {
//    typealias Value = CGFloat
//    static var defaultValue = CGFloat.zero
//
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//struct ProfileHeader: View {
//    @State private var showingImagePicker = false
//    @State private var inputImage: UIImage?
//    @State private var communityImageUrl: String?
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            if let imageUrl = communityImageUrl {
//                AsyncImage(url: URL(string: imageUrl))
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
//                    .shadow(radius: 10)
//                    .padding(.top)
//            } else {
//                Image("placeholder_image") // 一個預設圖片
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 80, height: 80)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
//                    .shadow(radius: 10)
//                    .padding(.top)
//            }
//
//            Button(action: {
//                showingImagePicker = true
//            }) {
//                Text("更換圖片")
//            }
//            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
//                ImagePicker(image: $inputImage)
//            }
//
//            Text("用戶名稱")
//                .font(.title)
//                .bold()
//
//            Text("@username")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            Text("這裡是用戶的自我介紹。這裡是用戶的自我介紹。")
//                .padding(.top, 8)
//
//            HStack(spacing: 40) {
//                VStack {
//                    Text("貼文")
//                        .font(.subheadline)
//                    Text("1,234")
//                        .font(.headline)
//                }
//
//                VStack {
//                    Text("關注中")
//                        .font(.subheadline)
//                    Text("567")
//                        .font(.headline)
//                }
//
//                VStack {
//                    Text("追蹤者")
//                        .font(.subheadline)
//                    Text("890")
//                        .font(.headline)
//                }
//            }
//            .padding(.top, 16)
//        }
//        .padding()
//    }
//
//    func loadImage() {
//        guard let inputImage = inputImage else { return }
//        uploadImageToFirebase(inputImage)
//    }
//
//    func uploadImageToFirebase(_ image: UIImage) {
//        let data = image.jpegData(compressionQuality: 0.8)!
//        let storage = Storage.storage().reference().child("community_images/\(UUID().uuidString).jpg")
//
//        storage.putData(data, metadata: nil) { _, error in
//            if let error = error {
//                print("Error uploading: \(error)")
//                return
//            }
//
//            storage.downloadURL { url, error in
//                if let error = error {
//                    print("Error getting download URL: \(error)")
//                    return
//                }
//
//                if let url = url {
//                    // 儲存這個 URL 到 Firestore
//                    let db = Firestore.firestore()
//                    db.collection("community_images").addDocument(data: ["imageUrl": url.absoluteString])
//
//                    // 更新 communityImageUrl 以顯示新的圖片
//                    communityImageUrl = url.absoluteString
//                }
//            }
//        }
//    }
//}
//
//struct PostsListView: View {
//    var body: some View {
//        List {
//            ForEach(1...10, id: \.self) { _ in
//                PostView()
//            }
//        }
//    }
//}
//
//struct CommunityProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityProfileView()
//    }
//}

