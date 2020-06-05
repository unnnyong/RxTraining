//
//  PeopleTableViewCell.swift
//  RxStarwars
//
//  Created by Eunyeong Kim on 2020/06/04.
//  Copyright © 2020 Eunyeong Kim. All rights reserved.
//

import UIKit

final class PeopleTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!

    func update(with person: Person) {
        nameLabel.text = person.name
        heightLabel.text = person.height
    }

}
