//
//  DateTests.swift
//  InstaChainTests
//
//  Created by Pei on 2019/5/9.
//  Copyright © 2019 WWK. All rights reserved.
//

import XCTest
@testable import InstaChain

class DateTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSecondsAgo() {
        let date = Date(timeIntervalSinceNow: -59)
        XCTAssertEqual("59 seconds", date.getElapsedInterval())
    }

    func testMinutesAgo() {
        let date = Date(timeIntervalSinceNow: -60 * 10)
        XCTAssertEqual("10 minutes", date.getElapsedInterval())
    }

    func testOneDayAgo() {
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        XCTAssertEqual("1 day", date.getElapsedInterval())
    }

    func testWeeksAgo() {
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24 * 15)
        XCTAssertEqual("2 weeks", date.getElapsedInterval())
    }

    func testMonthsAgo() {
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24 * 31)
        XCTAssertEqual("1 month", date.getElapsedInterval())
    }

}
