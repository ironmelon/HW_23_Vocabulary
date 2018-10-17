//
//  Word.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import Foundation

struct Word: Equatable {
    let englishWord: String
    let translateWord: String

    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.englishWord == rhs.englishWord && lhs.translateWord == rhs.translateWord
    }
}
