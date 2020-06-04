//
//  PeopleListViewModel.swift
//  RxStarwars
//
//  Created by Eunyeong Kim on 2020/06/04.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import Foundation
import RxSwift

final class PeopleListViewModel {

    var people = Observable<[Person]>.empty()
    let reload = PublishSubject<Void>()

    init() {
        people = reload.flatMap {
            APIClient().request()
        }
    }

}
