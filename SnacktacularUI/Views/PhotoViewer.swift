//
//  PhotoViewer.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 24/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct PhotoViewer: View {
    
    var spot: Spot
    var image: UIImage
    var description: String
    var reviewer: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                Spacer()
                Text(description)
                    .font(.subheadline)
                Text(reviewer)
                    .font(.caption)
                
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }

        }
    }
}

#Preview {
    PhotoViewer(spot: Spot(), image: UIImage(), description: "Test text", reviewer: "Someone")
}
