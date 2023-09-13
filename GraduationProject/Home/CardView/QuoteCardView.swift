//
//  QuoteCardView.swift
//  GraduationProject
//
//  Created by heonrim on 8/28/23.
//

import SwiftUI

struct QuoteCardView: View {
    @State var quote: String = "精通習慣由重複開始，而非完美。"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("每日一句")
                    .font(.headline)
                Spacer()
            }
            
            VStack {
                HStack {
                    Text(quote)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}

struct QuoteCardView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteCardView()
    }
}
