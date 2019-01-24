//
//  NewWordViewController.swift
//  HW_23_Vocabulary
//
//  Created by Oleg Dynnikov on 10/11/18.
//  Copyright © 2018 Oleg Dynnikov. All rights reserved.
//

import UIKit

protocol NewWordDelegate: class {
    func didAddNewWordToWordsList()
}

class NewWordViewController: UIViewController {

    @IBOutlet private weak var englishTextField: UITextField!
    @IBOutlet private weak var russianTextField: UITextField!

    weak var delegate: NewWordDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Word"
        englishTextField.delegate = self
        russianTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    private func hideKeyboard() {
        view.endEditing(true)
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Actions
    @IBAction private func addPressed(_ sender: Any) {
        guard let engWord = englishTextField.text, !engWord.isEmpty else { return }
        guard let rusWord = russianTextField.text, !rusWord.isEmpty else { return }
        let newWord = Word(englishWord: engWord, translateWord: rusWord)
        DataManager.instance.addNewWord(newWord)
        delegate?.didAddNewWordToWordsList()
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Selectors
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        view.backgroundColor = .darkGray
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        view.backgroundColor = .lightGray
    }
}

// MARK: - Extensions
extension NewWordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == englishTextField {
            textField.resignFirstResponder()
            russianTextField.becomeFirstResponder()
        } else { hideKeyboard() }
        return true
    }
}
