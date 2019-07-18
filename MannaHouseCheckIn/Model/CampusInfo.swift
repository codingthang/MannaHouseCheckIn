//
//  CampusInfo.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/16/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import Foundation

struct CampusInfo : Hashable{
    let title: String?
    let href: String?
    
    init(dictionary: [String:Any]) {
        title = dictionary["title"] as? String
        href = dictionary["href"] as? String
    }
}
