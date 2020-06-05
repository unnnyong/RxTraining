//
//  APIClientMock.swift
//  RxStarwarsTests
//
//  Created by Eunyeong Kim on 2020/06/06.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

@testable import RxStarwars

import Foundation
import RxSwift

final class APIClientMock: APIClientProtocol {
    var expectingRequestResult: [Person]!

    func request() -> Observable<[Person]> {
        return BehaviorSubject<[Person]>(value: expectingRequestResult)
    }
}
