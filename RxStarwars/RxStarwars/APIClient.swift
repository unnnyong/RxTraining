//
//  APIClient.swift
//  RxStarwars
//
//  Created by Eunyeong Kim on 2020/06/04.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import Foundation
import RxSwift

enum RequestError: Error {
    case nonexistentURL
    case noData
}

protocol APIClientProtocol {
    func request() -> Observable<[Person]>
}

struct APIClient: APIClientProtocol {
    private let url = URL(string: "https://swapi.dev/api/people")

    func request() -> Observable<[Person]> {
        return Observable.create { observer -> Disposable in
            guard let url = self.url else {
                observer.onError(RequestError.nonexistentURL)

                return Disposables.create()
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in

                if let data = data,
                    let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any],
                    let peopleDict = dataDict["results"] as? [[AnyHashable: Any]] {

                    let people = peopleDict.compactMap { Person(dict: $0) }
                                            .shuffled() // Reload 때 새로운 request가 되었나 확인을 위해서.

                    return observer.onNext(people)
                }

                if let error = error {
                    return observer.onError(error)
                }

                return observer.onError(RequestError.noData)
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
