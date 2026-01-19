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
    
    init(id: String? = nil, title: String = "", body: String = "", rating: Int = 0, reviewer: String = Auth.auth().currentUser?.email ?? "", postedOn: Date = Date()) {
        self.id = id
        self.title = title
        self.body = body
        self.rating = rating
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Review {
    
    static var preview: Review {
        let newReview = Review(
            id: "1",
            title: "Test Review",
            body: "Mock data to review the place",
            rating: 3,
            reviewer: "Steve",
            postedOn: Date()
        )
        return newReview
    }
}
