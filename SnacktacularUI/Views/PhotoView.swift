//
//  PhotoView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 17/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import PhotosUI

struct PhotoView: View {
    
    @State var spot: Spot // passed in from SpotDetailView
    @State private var selectedPhoto: PhotosPickerItem? // Selected image from photo Gallery
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            selectedImage
                .resizable()
                .scaledToFit()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            // TODO: Add save code
                            dismiss()
                        }
                    }
                }
                .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
                .onChange(of: selectedPhoto) {
                    Task {
                        do {
                            if let image = try await selectedPhoto?.loadTransferable(type: Image.self) {
                                selectedImage = image
                            }
                            
                        } catch {
                            print("😡 ERROR: Could not create Image from selectedPhoto. \(error.localizedDescription)")
                        }
                    }
                }
        }
        .padding()
    }
}

#Preview {
    PhotoView(spot: Spot())
}
