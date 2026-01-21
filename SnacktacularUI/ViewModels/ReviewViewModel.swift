//
//  ReviewViewModel.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 19/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import Foundation
import FirebaseFirestore

@Observable
class ReviewViewModel {
    
    
    static func saveReview(spot: Spot, review: Review) async -> String? {
        
        guard let spotID = spot.id else {
            print("😡 ERROR: Should have bever been called without a valid spot.id")
            return nil
        }
        
        let db = Firestore.firestore()
        //let path = "spots/\(id)/reviews" // all reviews will be saved in a folder with its spot document name
        
        let collectionString = "spots/\(spotID)/reviews"
        
        if let id = review.id {
            
            // review already exists, so need to update it
            do {
                print("Review that is going to be saved: \(review.title) \(review.rating)")
                try db.collection(collectionString).document(id).setData(from: review)
                print("😎 Review Data updated successfully! \(id)")
                return id
            } catch {
                print("😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return id
            }
            
        } else {
            //review.id = UUID().uuidString // unique filename for review when its stored
            // add new review
            do {
                let docRef = try db.collection(collectionString).addDocument(from: review)
                print("🐣 Review Data added successfully!")
                return docRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    
    static func deleteReview(spot: Spot, review: Review) {
        let db = Firestore.firestore()
        
        guard let spotID = spot.id, let reviewID = review.id else {
            print("No spot.id")
            return
        }
        
        let collectionString = "spots/\(spotID)/reviews"
        
        Task {
            do {
                try await db.collection(collectionString).document(reviewID).delete()
            } catch {
                print("😡 ERROR: Could not delete the document \(reviewID). \(error.localizedDescription)")
            }
        }
    }
}
