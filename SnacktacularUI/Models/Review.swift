//
//  Review.swift
//  SnacktacularUI
//
//  Created by app-kaihatsusha on 18/01/2026.
//  Copyright © 2026 app-kaihatsusha. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
}
