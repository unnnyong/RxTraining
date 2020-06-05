//
//  RxStarwarsTests.swift
//  RxStarwarsTests
//
//  Created by Eunyeong Kim on 2020/06/05.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

@testable import RxStarwars

import XCTest
import RxSwift
import RxTest

class RxStarwarsTests: XCTestCase {

    var subject: PeopleListViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var apiClient: APIClientMock!

    override func setUp() {
        super.setUp()

        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        apiClient = APIClientMock()
        subject = PeopleListViewModel(apiCleint: apiClient)
    }

    func test_reload_successRequest() {
        // reload 를 요청하는 친구
        let requestReload = scheduler.createHotObservable([
            .next(100, Void()),
            .next(130, Void())
        ])

        requestReload
            .bind(to: subject.reload)
            .disposed(by: disposeBag)

        // people 을 만드는 친구
        let peopleMock = [Person(dict: ["name": "Yoda", "height": "123"])]
        apiClient.expectingRequestResult = peopleMock

        let observer = scheduler.createObserver([Person].self)
        subject.people
            .asDriver(onErrorJustReturn: [])
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(
            observer.events,
            [.next(100, peopleMock),
             .next(130, peopleMock)]
        )
    }

    func test_reload_failureRequest() {
        let requestReload = scheduler.createHotObservable([
            .next(100, Void()),
            .next(130, Void())
        ])

        requestReload
            .bind(to: subject.reload)
            .disposed(by: disposeBag)

        apiClient.expectingRequestResult = []

        let observer = scheduler.createObserver([Person].self)

        subject.people
            .asDriver(onErrorJustReturn: [])
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(
            observer.events,
            [.next(100, []),
             .next(130, [])]
        )
    }

}
