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
    weak var delegate: LearnedWordsDelegate?
    var currentWords: Int = 0
    var filteredWords = [Word]()
    var isActiveSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Learned Words"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailVC" else { return }
        guard let destVC = segue.destination as? DetailViewController else { return }
        guard let tableCell = sender as? LearnedWordTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: tableCell) else { return }
        let learnedWord = DataManager.instance.learnedWords[indexPath.row]
        destVC.word = learnedWord
        destVC.screen = .learnedWord 
        destVC.delegate = self
    }
}

// MARK: - Extensions

extension LearnedWordsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActiveSearch ? filteredWords.count : DataManager.instance.learnedWords.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LearnedWordTableViewCell", for: indexPath) as? LearnedWordTableViewCell else {
            fatalError("LearnedWordTableViewCell creation failed.")
        }
        let learnedWord = isActiveSearch ? filteredWords[indexPath.row] : DataManager.instance.learnedWords[indexPath.row]
        cell.update(engWord: learnedWord.englishWord, transWord: learnedWord.translateWord)
        return cell
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
