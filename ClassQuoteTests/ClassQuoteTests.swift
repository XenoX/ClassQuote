//
//  ClassQuoteTests.swift
//  ClassQuoteTests
//
//  Created by XenoX on 29/03/2019.
//  Copyright © 2019 XenoX. All rights reserved.
//

import XCTest
@testable import ClassQuote

class ClassQuoteTests: XCTestCase {

    func testGetQuoteShouldPostFailedCallbackIfError() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackIfNoData() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(data: nil, response: nil, error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackIfNoPictureData() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedNotificationIfErrorWhileRetrievingPicture() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: FakeResponseData.error))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackBadResponseWhileRetrievingPicture() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseKO,
                error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackIfIncorrectResponse() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseKO,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostFailedCallbackIfIncorrectData() {
        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteIncorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(data: nil, response: nil, error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertFalse(success)
            XCTAssertNil(quote)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetQuoteShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let text = [
            "Instead of saying that man is the creature of circumstance, ",
            "it would be nearer the mark to say that man is the architect of circumstance."
        ].joined()
        let author = "Thomas Carlyle"
        let imageData = "image".data(using: .utf8)!

        let quoteService = QuoteService(
            quoteSession: URLSessionFake(
                data: FakeResponseData.quoteCorrectData,
                response: FakeResponseData.responseOK,
                error: nil),
            imageSession: URLSessionFake(
                data: FakeResponseData.imageData,
                response: FakeResponseData.responseOK,
                error: nil))

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        quoteService.getQuote { (success, quote) in
            XCTAssertTrue(success)
            XCTAssertNotNil(quote)

            XCTAssertEqual(text, quote!.text)
            XCTAssertEqual(author, quote!.author)
            XCTAssertEqual(imageData, quote!.imageData)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
