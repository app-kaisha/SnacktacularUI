//
//  ReviewView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 18/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI

struct ReviewView: View {
    
    @State var spot: Spot
    @State var review: Review
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text(spot.name)
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                    Text(spot.address)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Click to Rate:")
                    .font(.title2).bold()
                HStack {
                    StarSelectionView(rating: $review.rating)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                                .padding(.horizontal)
                            
                        }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .bold()
                    
                    TextField("title", text: $review.title)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                    
                    Text("Review")
                        .bold()
                    TextField("review", text: $review.body, axis: .vertical)
                        .padding(.horizontal, 6)
                        .autocorrectionDisabled()
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                }
                .padding(.horizontal)
                .font(.title2)

                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            saveReview()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func saveReview() {
        Task {
            guard let id = await ReviewViewModel.saveReview(spot: spot, review: review) else {
                print("😡 ERROR: Saving spot from Save button.")
                return
            }
            print("review.id \(id)")
            print("😎 Nice Review save!")
        }
        
    }
}

#Preview {
    ReviewView(spot: Spot(name: "Shake Shack", address: "49 Boyleston St., Chestnut Hill, MA 02467"), review: Review())
}
