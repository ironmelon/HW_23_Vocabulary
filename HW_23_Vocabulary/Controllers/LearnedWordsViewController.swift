//
//  LearnedWordsViewController.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/12/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

protocol LearnedWordsDelegate: class {
    func didUnlearnWord()
}

class LearnedWordsViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    static let identifier = "LearnedWordsViewController"

    weak var delegate: LearnedWordsDelegate?

    var currentWords: Int = 0
    var filteredWords = [Word]()
    var isActiveSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Learned Words"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(LearnedWordTableViewCell.nib, forCellReuseIdentifier: LearnedWordTableViewCell.identifier)

        searchBar.delegate = self
        currentWords = DataManager.instance.learnedWords.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isActiveSearch {
            isActiveSearch = false
            tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isActiveSearch {
            searchBar.text = ""
            hideKeyboard()
        }
        if currentWords > DataManager.instance.learnedWords.count {
            delegate?.didUnlearnWord()
        }
    }

    private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extensions

extension LearnedWordsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActiveSearch ? filteredWords.count : DataManager.instance.learnedWords.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            fatalError("DetailViewController open failed")
        }
        let learnedWord = DataManager.instance.learnedWords[indexPath.row]
        detailVC.word = learnedWord
        detailVC.screen = .learnedWord
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LearnedWordTableViewCell.identifier, for: indexPath) as? LearnedWordTableViewCell else {
            fatalError("LearnedWordTableViewCell creation failed.")
        }
        let learnedWord = isActiveSearch ? filteredWords[indexPath.row] : DataManager.instance.learnedWords[indexPath.row]
        cell.update(engWord: learnedWord.englishWord, transWord: learnedWord.translateWord)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        DataManager.instance.removeWordFromLearnedAtIndex(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension LearnedWordsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isActiveSearch = !searchText.isEmpty
        filteredWords = []

        for word in DataManager.instance.learnedWords {
            if word.englishWord.lowercased().contains(searchText.lowercased()) ||
                word.translateWord.lowercased().contains(searchText.lowercased()) {
                filteredWords.append(word)
            }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

extension LearnedWordsViewController: DetailViewDelegate {
        func didLearnWord() { tableView.reloadData() }
}
