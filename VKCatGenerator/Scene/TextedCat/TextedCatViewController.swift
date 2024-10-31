//
//  TextedCatViewController.swift
//  CatGenerator
//
//  Created by Konstantin on 31.10.2024.
//

import UIKit

class TextedCatViewController: UIViewController {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var generateCatButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = "Готов к загрузке!"
        textLabel.text = ""
        activityIndicator.hidesWhenStopped = true
    }

    @objc
    private func didTapView() {
        view.endEditing(true)
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        statusLabel.text = "Загружаю кота!"
        generateCatButton.isEnabled = false
        textField.isEnabled = false

        downloadCat()
    }

    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data else {
                self.onDownloadingFinished("Ошибка загрузки(")
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.onDownloadingFinished("")
                self?.textLabel.text = self?.textField.text
                self?.catImageView.image = UIImage(data: data)
            }
        }

        task.resume()
    }

    private func onDownloadingFinished(_ statusText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.generateCatButton.isEnabled = true
            self?.textField.isEnabled = true
            self?.activityIndicator.stopAnimating()
            self?.statusLabel.text = statusText
        }
    }
}
