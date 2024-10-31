//
//  CatViewController.swift
//  CatGenerator
//
//  Created by Konstantin on 31.10.2024.
//

import UIKit

class CatViewController: UIViewController {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var generateCatButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = "Готов к загрузке!"
        activityIndicator.hidesWhenStopped = true
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        activityIndicator.startAnimating()
        statusLabel.text = "Загружаю кота!"
        generateCatButton.isEnabled = false

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
                self?.catImageView.image = UIImage(data: data)
            }
        }

        task.resume()
    }

    private func onDownloadingFinished(_ statusText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.generateCatButton.isEnabled = true
            self?.activityIndicator.stopAnimating()
            self?.statusLabel.text = statusText
        }
    }

}
