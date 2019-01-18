//
//  DetailViewController.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

protocol DetailViewDelegate: class {
    func didLearnWord()
}

class DetailViewController: UIViewController {

    enum ContentType {
        case word
        case learnedWord
    }

    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet private weak var russianLabel: UILabel!
    @IBOutlet private weak var pressButton: UIButton!

    weak var delegate: DetailViewDelegate?
    var word: Word?
    var screen: ContentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Translation"
        englishLabel.text = word?.englishWord ?? ""
        russianLabel.text = word?.translateWord ?? ""
        checkPressButton()
    }

    private func checkPressButton() {
        let buttonTitle = screen == .word ? "LEARNED" : "UNLEARNED"
        pressButton.setTitle(buttonTitle ,for: .normal)
    }

    // MARK: - Actions
    @IBAction private func pressedButton(_ sender: Any) {
        guard let word = word else { return }
        if screen == ContentType.word {
            DataManager.instance.markAsLearned(word)
        } else if screen == ContentType.learnedWord {
            DataManager.instance.markAsUnlearned(word)
        }
        delegate?.didLearnWord()
        navigationController?.popViewController(animated: true)
    }
}
