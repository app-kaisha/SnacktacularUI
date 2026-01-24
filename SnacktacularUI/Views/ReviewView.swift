//
//  ReviewView.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 18/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ReviewView: View {
    
    @State var spot: Spot
    @State var review: Review
    
    @State private var postedByThisUser = false
    @State private var rateOrReviewString = "Click to Rate:"
    
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
                
                Text(rateOrReviewString)
                    .font(postedByThisUser ? .title2 : .subheadline)
                    .bold(postedByThisUser)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal)
                HStack {
                    StarSelectionView(rating: $review.rating)
                        .disabled(!postedByThisUser)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                                .padding(.horizontal)
                        }
                }
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .bold()
                    
                    TextField("title", text: $review.title)
                        .padding(.horizontal, 6)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                        }
                    
                    Text("Review")
                        .bold()
                    TextField("review", text: $review.body, axis: .vertical)
                        .padding(.horizontal, 6)
                        .autocorrectionDisabled()
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0.3)
                        }
                }
                .disabled(!postedByThisUser)
                .padding(.horizontal)
                .font(.title2)

                Spacer()
            }
            .navigationBarBackButtonHidden(postedByThisUser)
            .onAppear {
                if review.reviewer == Auth.auth().currentUser?.email {
                    postedByThisUser = true
                } else {
                    let reviewPostedOn = review.postedOn.formatted(date: .abbreviated, time: .omitted)
                    rateOrReviewString = "by: \(review.reviewer) on: \(reviewPostedOn)"
                }
            }
            .toolbar {
                if postedByThisUser {
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
                    if review.id != nil {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Button {
                                Task {
                                    let success = await ReviewViewModel.deleteReview(spot: spot, review: review)
                                    
                                    if success {
                                        dismiss()
                                    }
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                            
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
