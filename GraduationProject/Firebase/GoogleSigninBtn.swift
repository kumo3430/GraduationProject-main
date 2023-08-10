//
//  GoogleSigninBtn.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import SwiftUI
//import UIKit

struct GoogleSigninBtn: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .shadow(color: .gray, radius: 4, x: 0, y: 2)
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
                    .mask(
                        Circle()
                    )
            }
        }
        .frame(width: 50, height: 50)
    }
}

struct GoogleSigninBtn_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSigninBtn(action: {})
    }
}
