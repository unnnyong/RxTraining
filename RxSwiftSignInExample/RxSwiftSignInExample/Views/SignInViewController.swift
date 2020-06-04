//
//  SignInViewController.swift
//  RxSwiftSignInExample
//
//  Created by Eunyeong Kim on 2020/05/31.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {

    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var informationLabel: UILabel!

    private var informationLabelTextColor: Binder<UIColor> {
        Binder(self) { vc, textColor in
            vc.informationLabel.textColor = textColor
        }
    }

    private let disposeBag = DisposeBag()

    private lazy var viewModel = SignInViewModel(idTextObservable: self.idTextField.rx.text.asObservable(),
                                                 passwordTextObservable: self.passwordTextField.rx.text.asObservable())

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.validationText
            .bind(to: informationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.informationLabelColor
            .bind(to: informationLabelTextColor)
            .disposed(by: disposeBag)
    }

}

