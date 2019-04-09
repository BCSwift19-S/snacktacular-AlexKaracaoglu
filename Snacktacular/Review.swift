//
//  Review.swift
//  Snacktacular
//
//  Created by Alex Karacaoglu on 4/9/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Review {
    var title: String
    var text: String
    var rating: Int
    var reviewerUserId: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["title": title, "text": text, "rating": rating, "reviewerUserId": reviewerUserId, "date": date, "documentID": documentID]
    }
    
    init(title: String, text: String, rating: Int, reviewerUserId: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserId = reviewerUserId
        self.date = date
        self.documentID = documentID
    }
    
    convenience init() {
        let currentUserId = Auth.auth().currentUser?.email ?? "Unknown user"
        self.init(title: "", text: "", rating: 0, reviewerUserId: currentUserId, date: Date(), documentID: "")
    }
    
    func saveData(spot: Spot, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("Error updating document \(error)")
                    completed(false)
                }
                else {
                    completed(true)
                }
            }
        }
        else {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Error creating document \(error)")
                    completed(false)
                }
                else {
                    completed(true)
                }
            }
        }
    }
    
}
