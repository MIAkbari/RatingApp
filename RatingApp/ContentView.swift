//
//  ContentView.swift
//  RatingApp
//
//  Created by Mohammad on 9/6/25.
//

import SwiftUI

struct ContentView: View {
    @State var rating: Float = 3.7
    @State var width: CGFloat = 200

    var body: some View {
        VStack(spacing: 30) {
            StarRatingView(rating: $rating, width: $width)
                .frame(height: 30)
            
            HStack {
                StarRatingView(rating: $rating, width: $width,
                               color: .red)
                    .frame(height: 30)
            }
        }
    }
}



#Preview {
    ContentView()
}
