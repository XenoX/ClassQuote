//
//  ViewController.swift
//  ClassQuote
//
//  Created by XenoX on 29/03/2019.
//  Copyright © 2019 XenoX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newQuoteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getQuote()
    }

    @IBAction func didTapNewQuoteButton(_ sender: UIButton) {
        getQuote()
    }

    private func getQuote() {
        toggleActivityIndicator(shown: true)

        QuoteService.shared.getQuote { (success, quote) in
            self.toggleActivityIndicator(shown: false)

            if success, let quote = quote {
                self.updateQuote(quote: quote)
            } else {
                self.presentAlert()
            }
        }
    }

    private func toggleActivityIndicator(shown: Bool) {
        newQuoteButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }

    private func updateQuote(quote: Quote) {
        quoteLabel.text = quote.text
        authorLabel.text = quote.author
        imageView.image = UIImage(data: quote.imageData)
    }

    private func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "The quote download failed.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
