//
//  StarSelectionView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 18/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct StarSelectionView: View {
    
    @Binding var rating: Int // test - needs to be binding
    let highestRating = 5
    let unselected = Image(systemName: "star")
    let selected = Image(systemName: "star.fill")
    let font: Font = .largeTitle
    let fillColour: Color = .red
    let emptyColour: Color = .gray
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .foregroundStyle(number <= rating ? fillColour : emptyColour)
                    .onTapGesture {
                        rating = number
                    }
            }
            .font(font)
        }
    }
    
    func showStar(for number: Int) -> Image {
        return number > rating ? unselected : selected
    }
}

#Preview {
    StarSelectionView(rating: .constant(1))
}
