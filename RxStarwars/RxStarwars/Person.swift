//
//  Person.swift
//  RxStarwars
//
//  Created by Eunyeong Kim on 2020/06/04.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let height: String

    init(dict: [AnyHashable: Any]) {
        name = dict["name"] as? String ?? ""
        height = dict["height"] as? String ?? ""
    }
}
