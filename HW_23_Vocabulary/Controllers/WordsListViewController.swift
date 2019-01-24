//
//  WordsListViewController.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

class WordsListViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    var filteredWords = [Word]()
    var isActiveSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Words List"
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
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
    }

    private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
        case "showDetailVC":
            guard let destVC = segue.destination as? DetailViewController else { return }
            guard let tableCell = sender as? WordTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: tableCell) else { return }
            let word = isActiveSearch ? filteredWords[indexPath.row] : DataManager.instance.words[indexPath.row]
            destVC.screen = .word
            destVC.delegate = self
            destVC.word = word
        case "showNewWordVC":
            guard let destVC = segue.destination as? NewWordViewController else { return }
            destVC.delegate = self
        case "showLearnedWords":
            guard let destVC = segue.destination as? LearnedWordsViewController else { return }
            destVC.delegate = self
        default:
            return
        }
    }
}

// MARK: - Extansions

extension WordsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isActiveSearch ? filteredWords.count : DataManager.instance.words.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "WordTableViewCell", for: indexPath) as? WordTableViewCell else {
            fatalError("WorldTableViewCell creation failed.")
        }
        let word = isActiveSearch ? filteredWords[indexPath.row] : DataManager.instance.words[indexPath.row]
        cell.update(englishWord: word.englishWord)
        return cell
    }
}

extension WordsListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isActiveSearch = !searchText.isEmpty
        filteredWords = []

        for word in DataManager.instance.words {
            if word.englishWord.lowercased().contains(searchText.lowercased()) {
                filteredWords.append(word)
            }
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

extension WordsListViewController: NewWordDelegate {
    func didAddNewWordToWordsList() { tableView.reloadData() }
}

extension WordsListViewController: DetailViewDelegate {
    func didLearnWord() { tableView.reloadData() }
}

extension WordsListViewController: LearnedWordsDelegate {
    func didUnlearnWord() { tableView.reloadData() }
}
