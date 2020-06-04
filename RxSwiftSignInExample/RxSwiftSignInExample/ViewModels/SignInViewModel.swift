//
//  ViewModel.swift
//  RxSwiftSignInExample
//
//  Created by Eunyeong Kim on 2020/05/31.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewModel {
    let validationText: Observable<String>
    let informationLabelColor: Observable<UIColor>

    private var signInInfo: Observable<SignInInfo>

    init(
        idTextObservable: Observable<String?>,
        passwordTextObservable: Observable<String?>
    ) {
        // signInInfo initialize
        self.signInInfo = Observable
            .combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .flatMap { Observable.just(SignInInfo(id: $0.0, password: $0.1)) }
            .share()

        let event = signInInfo
            .flatMap { info -> Observable<Event<Void>> in
                return info.validate().materialize()
            }
            .share()

        // validationText initialize
        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("ID와 Password가 입력되었습니다.")
                case .error(let error):
                    return .just((error as? SignInValidationError)?.message ?? error.localizedDescription)
                case .completed:
                    return .just("입력은 DONE!")
                }
            }
            .startWith("ID와 Password를 입력해주세요.")

        // informationLabelColor initialize
        self.informationLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error:
                    return .just(.red)
                case .completed:
                    return .just(.black)
                }
            }
            .startWith(.black)
    }

}
