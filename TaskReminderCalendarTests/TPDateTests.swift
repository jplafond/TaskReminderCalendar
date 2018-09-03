//
//  TPDateTests.swift
//  TaskReminderCalendarTests
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import XCTest
@testable import TaskReminderCalendar

class TPDateTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - TPDate Validation
    func testValidDates() {
        for month in TPDate.months {
            let maxDay = TPDate.days[month]

            for day in 1...maxDay! {
                let tpDate = TPDate(year: 2018, month: month, day: day)
                XCTAssertNotNil(tpDate)
                XCTAssert(tpDate!.year == 2018)
                XCTAssert(tpDate!.month == month)
                XCTAssert(tpDate!.day == day)
            }
        }
    }

    func testInvalidDates() {
        for month in TPDate.months {
            let maxDay = TPDate.days[month]
            XCTAssert(nil == TPDate(year: 2018, month: month, day: 0))
            XCTAssert(nil == TPDate(year: 2018, month: month, day: maxDay! + 1))
        }
    }

    func testNormalizeYear() {
        let tpDate = TPDate(year: 18, month: 1, day: 1)
        XCTAssertNotNil(tpDate)
        XCTAssert(tpDate!.year == 2018)
    }

    func testIsLeapYear() {
        XCTAssertTrue(TPDate.isLeapYear(year: 0000))
        XCTAssertTrue(TPDate.isLeapYear(year: 0004))
        XCTAssertFalse(TPDate.isLeapYear(year: 0100))
        XCTAssertTrue(TPDate.isLeapYear(year: 0400))
        XCTAssertFalse(TPDate.isLeapYear(year: 0007))
        XCTAssertFalse(TPDate.isLeapYear(year: 1900))
        XCTAssertTrue(TPDate.isLeapYear(year: 2000))
        XCTAssertTrue(TPDate.isLeapYear(year: 2020))
    }

    func testValidHours() {
        for hour in 0...23 {
            XCTAssertTrue(TPDate.isValid(hour: hour))
        }
    }

    func testInvalidHours() {
        XCTAssertFalse(TPDate.isValid(hour: -1))
        XCTAssertFalse(TPDate.isValid(hour: 24))
    }

    func testValidMinutes() {
        for minute in 0...59 {
            XCTAssertTrue(TPDate.isValid(minute: minute))
        }
    }

    func testInvalidMinutes() {
        XCTAssertFalse(TPDate.isValid(minute: -1))
        XCTAssertFalse(TPDate.isValid(minute: 60))
    }

    // MARK: - TPReminder Validation
    func testValidReminders() {
        for hour in 0...23 {
            for minute in 0...59 {
                let tpReminder = TPDate(year: 2018, month: 09,
                                            day: 02, hour: hour,
                                            minute: minute)
                XCTAssertNotNil(tpReminder)
                XCTAssert(tpReminder!.hour == hour)
                XCTAssert(tpReminder!.minute == minute)
            }
        }
    }

    func testInvalidReminders() {
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                hour: -1, minute: 0))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                hour: 0, minute: -1))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                hour: 24, minute: 59))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                hour: 23, minute: 60))
    }

    // MARK: - TPAppointment Validation
    func testValidAppointments() {
        for hour in 0...22 {
            for minute in 0...59 {
                var endHour = hour
                var endMinute = minute
                if endMinute == 59 {
                    endHour += 1
                    endMinute = 00
                } else {
                    endMinute += 1
                }
                let tpAppt = TPDate(year: 2018, month: 09,
                                           day: 02, hour: hour,
                                           minute: minute,
                                           endHour: endHour,
                                           endMinute: endMinute)
                XCTAssertNotNil(tpAppt)
                XCTAssert(tpAppt!.endHour == endHour)
                XCTAssert(tpAppt!.endMinute == endMinute)
            }
        }
    }

    func testInvalidAppointments() {
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                   hour: 00, minute: 00,
                                   endHour: 00, endMinute: 00))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                   hour: 23, minute: 59,
                                   endHour: 00, endMinute: 00))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                   hour: 00, minute: 00,
                                   endHour: -1, endMinute: 00))
        XCTAssertNil(TPDate(year: 2018, month: 09, day: 02,
                                   hour: 00, minute: 00,
                                   endHour: 00, endMinute: 60))
    }

    // MARK: - Description Validation
    func testDateDescription() {
        var tpDate = TPDate(year: 18, month: 1, day: 1)
        var desc = tpDate!.description
        XCTAssert(desc == "2018-01-01", desc)

        tpDate = TPDate(year: 2018, month: 12, day: 31)
        desc = tpDate!.description
        XCTAssert(desc == "2018-12-31")
    }

    func testReminderDescription() {
        var tpReminder = TPDate(year: 18, month: 1, day: 1,
                                    hour: 0, minute: 0)
        var desc = tpReminder!.description
        XCTAssert(desc == "2018-01-01 00:00", desc)

        tpReminder = TPDate(year: 2018, month: 12, day: 31,
                                hour: 23, minute: 59)
        desc = tpReminder!.description
        XCTAssert(desc == "2018-12-31 23:59", desc)
    }

    func testAppointmentDescription() {
        let tpAppt = TPDate(year: 18, month: 1, day: 1,
                                   hour: 0, minute: 0,
                                   endHour: 23, endMinute: 59)
        let desc = tpAppt!.description
        XCTAssert(desc == "2018-01-01 00:00-23:59", desc)
    }

    // MARK: - DateString Initializers
    func testValidStrings() {
        let testDates = ["18-1-2",
                         "2018-01-02"]
        let testReminders = ["18-1-2 3:4",
                             "2018-01-02 03:04"]
        let testAppointments = ["18-1-2 3:4-5:6",
                                "2018-01-02 03:04-05:06"]
        for date in testDates {
            print("date <\(date)>")
            let tpDate = TPDate(dateString: date)
            XCTAssertNotNil(tpDate)
            XCTAssert(tpDate!.year == 2018)
            XCTAssert(tpDate!.month == 1)
            XCTAssert(tpDate!.day == 2)
            XCTAssertNil(tpDate!.hour)
            XCTAssertNil(tpDate!.minute)
            XCTAssertNil(tpDate!.endHour)
            XCTAssertNil(tpDate!.endMinute)
        }

        for date in testReminders {
            print("date <\(date)>")
            let tpDate = TPDate(dateString: date)
            XCTAssertNotNil(tpDate)
            XCTAssert(tpDate!.year == 2018)
            XCTAssert(tpDate!.month == 1)
            XCTAssert(tpDate!.day == 2)
            XCTAssert(tpDate!.hour == 3)
            XCTAssert(tpDate!.minute == 4)
            XCTAssertNil(tpDate!.endHour)
            XCTAssertNil(tpDate!.endMinute)
        }

        for date in testAppointments {
            print("date <\(date)>")
            let tpDate = TPDate(dateString: date)
            XCTAssertNotNil(tpDate)
            XCTAssert(tpDate!.year == 2018)
            XCTAssert(tpDate!.month == 1)
            XCTAssert(tpDate!.day == 2)
            XCTAssert(tpDate!.hour == 3)
            XCTAssert(tpDate!.minute == 4)
            XCTAssert(tpDate!.endHour == 5)
            XCTAssert(tpDate!.endMinute == 6)
        }
    }

    // MARK: - DateString Initializers
    func testInvalidStrings() {
        let testDates = ["",
                         "something",
                         "0-0-0",
                         "10-0-0",
                         "10-1-0",
                         "10-1-1 0:60",
                         "10-1-1 24:0",
                         "10-1-1 0:0-24:0",
                         "10-1-1 0:0-0:60",
                         "10-1-1 0:0-0:0-0:0"]
        for date in testDates {
            XCTAssertNil(TPDate(dateString: date), date)
        }
    }

}
