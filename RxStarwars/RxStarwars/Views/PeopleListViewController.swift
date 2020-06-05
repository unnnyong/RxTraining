//
//  PeopleListViewController.swift
//  RxStarwars
//
//  Created by Eunyeong Kim on 2020/06/02.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PeopleListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let refreshControl = UIRefreshControl()
    private let viewModel = PeopleListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindingViews()
    }

    private func setupViews() {
        tableView.refreshControl = refreshControl
    }

    private func bindingViews() {
        refreshControl.rx.controlEvent(.valueChanged)
            .filter { [weak self] in
                self?.refreshControl.isRefreshing == true
            }
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)

        viewModel.people
            .observeOn(MainScheduler.instance)
            .do(onNext:
                { [weak self] _ in self?.refreshControl.endRefreshing() }
            )
            .catchErrorJustReturn([])
            .bind(
                to: tableView.rx.items(cellIdentifier: "PeopleTableViewCell", cellType: PeopleTableViewCell.self)
            ) { _, person, cell in
                cell.update(with: person)
            }
            .disposed(by: disposeBag)
    }

}
