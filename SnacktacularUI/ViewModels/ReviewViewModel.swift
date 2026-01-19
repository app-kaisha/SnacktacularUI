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
    
    
    static func saveReview(spot: Spot, review: Review) async {
        
        guard let id = spot.id else {
            print("😡 ERROR: Should have bever been called without a valid spot.id")
            return
        }
        
        if review.id == nil {
            //review.id = UUID().uuidString // unique filename for review when its stored
        }
        
        let path = "\(id)/\(review.id ?? "n/a")" // all photos will be saved in a folder with its spot document name
        
        do {
            let db = Firestore.firestore()
            try db.collection("spots").document(id).collection("reviews").document(review.id ?? "n/a").setData(from: review)
            
        } catch {
            print("😡 ERROR: Could not update data in spots/\(id)/reviews/\(review.id ?? "n/a"). \(error.localizedDescription)")
        }
        
        
        
//        if let id = spot.id { // if spot id exists then update existing element
//            do {
//                try db.collection("spots").document(id).setData(from: spot)
//                print("😎 Data updated successfully!")
//                return id
//            } catch {
//                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
//                return id
//            }
//        } else { // id not present must be new element so add to db
//            do {
//                let docRef = try db.collection("spots").addDocument(from: spot)
//                print("🐣 Data added successfully!")
//                return docRef.documentID
//            } catch {
//                print("😡 ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
//                return nil
//            }
//        }
    }
    
    static func deleteReview(spot: Spot) {
        let db = Firestore.firestore()
        
        guard let id = spot.id else {
            print("No spot.id")
            return
        }
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
            } catch {
                print("😡 ERROR: Could not delete the document \(id). \(error.localizedDescription)")
            }
        }
    }
}
