//
//  QuoteService.swift
//  ClassQuote
//
//  Created by XenoX on 30/03/2019.
//  Copyright © 2019 XenoX. All rights reserved.
//

import Foundation

class QuoteService {
    static var shared = QuoteService()
    private init() { }

    private var task: URLSessionTask?

    private let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private let imageUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!

    func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        let request = createQuoteRequest()
        let session = URLSession(configuration: .default)

        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return callback(false, nil)
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return callback(false, nil)
                }

                guard let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                    let text = responseJSON["quoteText"],
                    let author = responseJSON["quoteAuthor"] else {
                    return callback(false, nil)
                }

                self.getImage { (data) in
                    if let data = data {
                        let quote = Quote(text: text, author: author, imageData: data)
                        callback(true, quote)
                    }
                }
            }
        }

        task?.resume()
    }

    private func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: imageUrl)

        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return completionHandler(nil)
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    return completionHandler(nil)
                }

                completionHandler(data)
            }
        }

        task?.resume()
    }

    private func createQuoteRequest() -> URLRequest {
        var request = URLRequest(url: quoteUrl)

        request.httpMethod = "POST"
        request.httpBody = "method=getQuote&lang=en&format=json".data(using: .utf8)

        return request
    }
}
