//
//  SpotDetailPhotoScrollView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 24/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct SpotDetailPhotoScrollView: View {
    
    var photos: [Photo]
    var spot: Spot
    
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var imageDescription = ""
    @State private var imageReviewer = ""
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4.0) {
                ForEach(photos) { photo in
                    let url = URL(string: photo.imageURLString)
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                uiImage = renderer.uiImage ?? UIImage()
                                imageDescription = photo.description
                                imageReviewer = "by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))"
                                showPhotoViewerView.toggle()
                            }
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoViewer(spot: spot, image: uiImage, description: imageDescription, reviewer: imageReviewer)
        }
    }
}

#Preview {
    SpotDetailPhotoScrollView(photos: [Photo.preview, Photo.preview], spot: Spot())
}
