//
//  DataManager.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import Foundation

final class DataManager {
    static let instance = DataManager()

    private init() {
        generateMockWords()
    }

    private(set) var words: [Word] = []
    private(set) var learnedWords: [Word] = []

    private func generateMockWords() {
        let word1 = Word(englishWord: "Ball", translateWord: "Мяч")
        let word2 = Word(englishWord: "Sister", translateWord: "Сестра")
        let word3 = Word(englishWord: "Sword", translateWord: "Меч")
        let word4 = Word(englishWord: "Game", translateWord: "Игра")
        let word5 = Word(englishWord: "War", translateWord: "Война")
        words = [word1, word2, word3, word4, word5]
    }

    //MARK: - Public functions
    func addNewWord(_ word: Word) {
        words.insert(word, at: 0)
    }

    func markAsLearned(_ word: Word) {
        guard let removeIndex = words.index(of: word) else { return }
        words.remove(at: removeIndex)
        learnedWords.insert(word, at: 0)
    }

    func markAsUnlearned(_ word: Word) {
        guard let removeIndex = learnedWords.index(of: word) else { return }
        learnedWords.remove(at: removeIndex)
        words.insert(word, at: 0)
    }
}
