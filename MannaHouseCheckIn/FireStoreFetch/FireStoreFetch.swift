//
//  FireStoreFetch.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/16/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import Foundation
import Firebase

class FireStoreFetch {
    func fetchFireStore(location: String, completion: @escaping ([Campus]) -> ()) {
         var campusArray = [Campus]()
        Firestore.firestore().collection(location).getDocuments(completion: { (query, err) in
            if let err = err {
                print("Error fetching collection: \(err.localizedDescription)")
                return
            }
            if let query = query?.documents {
                for document in query {
                    let campus = document.documentID
                    let dictionary = document.data()
                    campusArray.append(Campus(campus: campus, campusInfo: CampusInfo(dictionary: dictionary)))
                }
                completion(campusArray)
            }
        })
        
    }
}
