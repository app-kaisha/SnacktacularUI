//
//  SpotReviewRowView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 24/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct SpotReviewRowView: View {
    
    @State var review: Review
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title)
                .font(.title2)
            
            HStack {
                StarSelectionView(rating: $review.rating, interactive: false, font: .callout)
                Text(review.body)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    SpotReviewRowView(review: Review(title: "Fantastic Food!", body: "Love it so much apart from the service", rating: 3))
}
