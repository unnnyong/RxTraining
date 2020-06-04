//
//  SignInInfo.swift
//  RxSwiftSignInExample
//
//  Created by Eunyeong Kim on 2020/05/31.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import Foundation
import RxSwift

enum SignInValidationError: Error {
    case invalidIDAndPassword
    case invalidID
    case invalidPassword

    var message: String {
        switch self {
        case .invalidIDAndPassword:
            return "ID, Password를 입력해주십시오."
        case .invalidID:
            return "ID를 입력해주십시오."
        case .invalidPassword:
            return "Password를 입력해주십시오."
        }
    }
}

struct SignInInfo {
    var id: String?
    var password: String?

    func validate() -> Observable<Void> {
        let existID = !(id?.isEmpty ?? true)
        let existPassword = !(password?.isEmpty ?? true)

        if !existID && !existPassword {
            return Observable.error(SignInValidationError.invalidIDAndPassword)
        } else if existID && !existPassword {
            return Observable.error(SignInValidationError.invalidPassword)
        } else if !existID && existPassword {
            return Observable.error(SignInValidationError.invalidID)
        } else {
            return Observable.just(())
        }
    }
}
