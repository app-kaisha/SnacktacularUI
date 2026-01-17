//
//  PhotoViewModel.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 17/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import SwiftUI

class PhotoViewModel {
    static func saveImage(spot: Spot, photo: Photo, data: Data) async {
        guard let id = spot.id else {
            print("😡 ERROR: Should have bever been called without a valid spot.id")
            return
        }
        
        let storage = Storage.storage().reference()
        let metadata = StorageMetadata()
        if photo.id == nil {
            photo.id = UUID().uuidString // unique filename for photo when its stored
        }
        
        metadata.contentType = "image/jpeg" // allow image to be viewed in Firestore console
        let path = "\(id)/\(photo.id ?? "n/a")" // all photos will be saved in a folder with its spot document name
        
        do {
            let storageref = storage.child(path)
            let returnedMetaData = try await storageref.putDataAsync(data, metadata: metadata)
            // TODO: Delete as returned is a lot - this is just temporary viewing purpose
            print("😎 SAVED! \(returnedMetaData)")
            // get URL to be used to load image
            guard let url = try? await storageref.downloadURL() else {
                print("😡 ERROR: Could not get downloadURL.")
                return
            }
            
            photo.imageURLString = url.absoluteString
            print("photo.imageURLString: \(photo.imageURLString)")
            
            // Now photo file is saved in storage, save photo document to spot.id photo collection
            let db = Firestore.firestore()
            do {
                try db.collection("spots").document(id).collection("photos").document(photo.id ?? "n/a").setData(from: photo)
            } catch {
                print("😡 ERROR: Could not update data in spots/\(id)/photos/\(photo.id ?? "n/a"). \(error.localizedDescription)")
            }
            
        } catch {
            print("😡 ERROR: saving photo to Storage \(error.localizedDescription)")
        }
    }
}
