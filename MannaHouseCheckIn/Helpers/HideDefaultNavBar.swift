//
//  HideDefaultNavBar.swift
//  MannaHouseCheckIn
//
//  Created by JubalThang on 7/18/19.
//  Copyright © 2019 Jubal. All rights reserved.
//

import Foundation
import UIKit

struct System {
    static func hideDefaultNavBar(navBar : UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}
