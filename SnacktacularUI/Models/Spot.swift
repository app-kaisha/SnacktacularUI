//
//  Spot.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 17/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
}

extension Spot {
    static var preview: Spot {
        let newSpot = Spot(id: "1", name: "Boston Market", address: "Boston MA", latitude: 42.3601, longitude: -71.0589)
        return newSpot
    }
}
