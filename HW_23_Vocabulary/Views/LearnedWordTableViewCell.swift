//
//  LearnedWordTableViewCell.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/12/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

class LearnedWordTableViewCell: UITableViewCell {

    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet private weak var translatedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(engWord: String, transWord: String) {
        englishLabel.text = engWord
        translatedLabel.text = transWord
    }
}
