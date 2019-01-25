//
//  WordTableViewCell.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 1/25/19.
//  Copyright © 2019 Oleg Dynnikov. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {

    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var wordLabel: UILabel!

    static let nib = UINib(nibName: "WordTableViewCell", bundle: nil)
    static let identifier = "WordTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = statusView.bounds.width / 2
    }

    func update(englishWord: String) {
        wordLabel.text = englishWord
    }
}
