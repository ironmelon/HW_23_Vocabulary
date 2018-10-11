//
//  DetailViewController.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet private weak var russianLabel: UILabel!

    var word: Word?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Translation"
        englishLabel.text = word?.englishWord ?? ""
        russianLabel.text = word?.translateWord ?? ""
    }
}
