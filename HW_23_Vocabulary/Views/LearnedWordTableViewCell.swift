//
//  LearnedWordTableViewCell.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 1/25/19.
//  Copyright © 2019 Oleg Dynnikov. All rights reserved.
//

import UIKit

class LearnedWordTableViewCell: UITableViewCell {

    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet private weak var translatedLabel: UILabel!

    static let nib = UINib(nibName: "LearnedWordTableViewCell", bundle: nil)
    static let identifier = "LearnedWordTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func update(engWord: String, transWord: String) {
        englishLabel.text = engWord
        translatedLabel.text = transWord
    }
}
