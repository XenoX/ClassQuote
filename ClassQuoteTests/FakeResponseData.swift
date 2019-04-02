//
//  FakeResponseData.swift
//  ClassQuoteTests
//
//  Created by XenoX on 31/03/2019.
//  Copyright © 2019 XenoX. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var quoteCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Quote", withExtension: "json")!

        return (try? Data(contentsOf: url)) ?? Data()
    }

    static let quoteIncorrectData = "error".data(using: .utf8)!

    static let imageData = "image".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: nil)!

    // MARK: - Error
    class QuoteError: Error {}
    static let error = QuoteError()
}
