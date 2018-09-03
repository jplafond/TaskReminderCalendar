//
//  TPDate.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import Foundation

enum TPDate {
    case date(year: Int, month: Int, day: Int)
    case reminder(year: Int, month: Int, day: Int,
        hour: Int, minute: Int)
    case appointment(year: Int, month: Int, day: Int,
        beginHour: Int, beginMinute: Int,
        endHour: Int, endMinute: Int)

    // MARK: Numeric Initializer
    init?(year: Int, month: Int, day: Int,
          hour: Int? = nil, minute: Int? = nil,
          endHour: Int? = nil, endMinute: Int? = nil) {
        // Normalize years
        let normalizedYear: Int
        if 00 <= year && year <= 99 {
            normalizedYear = 2000 + year
        } else {
            normalizedYear = year
        }
        // Date validation
        guard TPDate.isValid(year: normalizedYear) &&
            TPDate.isValid(month: month) &&
            TPDate.isValid(year: normalizedYear, month: month, day: day) else {
                print("Invalid date: \(normalizedYear)-\(month)-\(day)")
                return nil
        }
        if let startHour = hour,
            let startMinute = minute {
            // Reminder validation
            guard TPDate.isValid(hour: startHour) &&
                TPDate.isValid(minute: startMinute) else {
                    print("Invalid start time: \(startHour):\(startMinute)")
                    return nil
            }
            if let endHour = endHour,
                let endMinute = endMinute {
                // Appointment validation
                guard TPDate.isValid(hour: endHour) &&
                    TPDate.isValid(minute: endMinute) else {
                        print("Invalid end time: \(endHour):\(endMinute)")
                        return nil
                }
                guard startHour < endHour ||
                    (startHour == endHour &&
                        startMinute < endMinute) else {
                            print("Invalid end time: \(endHour):\(endMinute)")
                            return nil
                }
                self = TPDate.appointment(year: normalizedYear, month: month,
                                          day: day, beginHour: startHour,
                                          beginMinute: startMinute,
                                          endHour: endHour,
                                          endMinute: endMinute)
            } else {
                self = TPDate.reminder(year: normalizedYear, month: month,
                                       day: day, hour: startHour,
                                       minute: startMinute)
            }
        } else {
            // Verify that the end hours aren't present
            guard endHour == nil && endMinute == nil else {
                print("Invalid end time: \(String(describing: endHour)):\(String(describing: endMinute))")
                return nil
            }
            self = TPDate.date(year:normalizedYear, month: month, day: day)
        }
    }

    // MARK: - Constants
    static let months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    static let days = [1: 31,
                       2: 28,
                       3: 31,
                       4: 30,
                       5: 31,
                       6: 30,
                       7: 31,
                       8: 31,
                       9: 30,
                       10: 31,
                       11: 30,
                       12: 31]
    static let monthShortNames = [1: "Jan",
                                  2: "Feb",
                                  3: "Mar",
                                  4: "Apr",
                                  5: "May",
                                  6: "Jun",
                                  7: "Jul",
                                  8: "Aug",
                                  9: "Sep",
                                  10: "Oct",
                                  11: "Nov",
                                  12: "Dec"]

    static let monthLongNames = [1: "January",
                                 2: "February",
                                 3: "March",
                                 4: "April",
                                 5: "May",
                                 6: "June",
                                 7: "July",
                                 8: "August",
                                 9: "September",
                                 10: "October",
                                 11: "November",
                                 12: "December"]

    struct regExKey {
        static let didMatch = 0
        static let yearOffset = 2
        static let monthOffset = 3
        static let dayOffset = 4
        static let hourOffset = 6
        static let minuteOffset = 7
        static let endHourOffset = 9
        static let endMinuteOffset = 10
    }

    struct regExKeys2 {
        static let didMatch = 0
        static let dateMatch = 1
        static let reminderMatch = 5
        static let appointmentMatch = 11
        static let yearOffset = 1
        static let monthOffset = 2
        static let dayOffset = 3
        static let hourOffset = 4
        static let minuteOffset = 5
        static let endHourOffset = 6
        static let endMinuteOffset = 7
    }

    // MARK: - Validators
    static func isLeapYear(year: Int) -> Bool {
        if (year % 4 == 0 && year % 100 != 0) ||
            (year % 400 == 0) {
            return true
        }
        return false
    }
    static func isValid(year: Int) -> Bool {
        return year > 0 && year <= 9999
    }
    static func isValid(month: Int) -> Bool {
        return self.months.contains(month)
    }
    static func isValid(year: Int, month: Int, day: Int) -> Bool {
        guard let maxDay = self.days[month] else {
            return false
        }
        if day < 1 || day > maxDay {
            if month == 2 && isLeapYear(year: year) {
                return day >= 1 && day < maxDay + 1
            }
            return false
        }
        return true
    }

    static func isValid(hour: Int) -> Bool {
        return 0 <= hour && hour <= 23
    }

    static func isValid(minute: Int) -> Bool {
        return 0 <= minute && minute <= 59
    }
}

// MARK: - Accessors
extension TPDate {
    var year: Int {
        switch self {
        case let .date(year, _, _):
            return year
        case let .reminder(year, _, _, _, _):
            return year
        case let .appointment(year, _, _, _, _, _, _):
            return year
        }
    }

    var month: Int {
        switch self {
        case let .date(_, month, _):
            return month
        case let .reminder(_, month, _, _, _):
            return month
        case let .appointment(_, month, _, _, _, _, _):
            return month
        }
    }

    var day: Int {
        switch self {
        case let .date(_, _, day):
            return day
        case let .reminder(_, _, day, _, _):
            return day
        case let .appointment(_, _, day, _, _, _, _):
            return day
        }
    }

    var hour: Int? {
        switch self {
        case let .reminder(_, _, _, hour, _):
            return hour
        case let .appointment(_, _, _, hour, _, _, _):
            return hour
        default:
            return nil
        }
    }

    var minute: Int? {
        switch self {
        case let .reminder(_, _, _, _, minute):
            return minute
        case let .appointment(_, _, _, _, minute, _, _):
            return minute
        default:
            return nil
        }
    }

    var endHour: Int? {
        switch self {
        case let .appointment(_, _, _, _, _, hour, _):
            return hour
        default:
            return nil
        }
    }

    var endMinute: Int? {
        switch self {
        case let .appointment(_, _, _, _, _, _, minute):
            return minute
        default:
            return nil
        }
    }

}

// MARK: - CustomStringConvertible
extension TPDate: CustomStringConvertible {
    var description: String {
        switch self {
        case let .date(year, month, day):
            return String(format: "%04d-%02d-%02d",
                          year, month, day)
        case let .reminder(year, month, day,
                           hour, minute):
            return String(format: "%04d-%02d-%02d %02d:%02d",
                          year, month, day, hour, minute)
        case let .appointment(year, month, day,
                              beginHour, beginMinute,
                              endHour, endMinute):
            return String(format: "%04d-%02d-%02d %02d:%02d-%02d:%02d",
                          year, month, day, beginHour, beginMinute, endHour, endMinute)
        }
    }
}

// MARK: - String Initializer
extension TPDate {
    init?(dateString: String) {
        // YY(YY)-MM-DD(( HH:MM)-HH:MM)
        let regexParser = "(^(\\d{2}|\\d{4})-(\\d{1,2})-(\\d{1,2})(\\s?(\\d{1,2}):(\\d{1,2}))?(-?(\\d{1,2}):?(\\d{1,2}))?$)"

        do {
            let regex = try NSRegularExpression(pattern: regexParser,
                                                options: .caseInsensitive)
            let fullRange = NSRange(dateString.startIndex...,
                                    in: dateString)
            let matches = regex.matches(in: dateString, options: .reportCompletion, range: fullRange)

            guard let match = matches.first else {
                print("No matches from <\(dateString)>")
                return nil
            }

            // Helper function
            func extract(from fromRange: NSRange) -> Int? {
                guard fromRange.location != NSNotFound else {
                    return nil
                }
                let string = String(dateString[Range(fromRange,
                                                     in: dateString)!])
                return Int(string)
            }

            // Get ranges
            guard TPDate.regExKey.endMinuteOffset <= match.numberOfRanges else {
                print("Parser issue")
                return nil
            }
            let yearRange = match.range(at: TPDate.regExKey.yearOffset)
            let monthRange = match.range(at: TPDate.regExKey.monthOffset)
            let dayRange = match.range(at: TPDate.regExKey.dayOffset)

            let hourRange = match.range(at: TPDate.regExKey.hourOffset)
            let minuteRange = match.range(at: TPDate.regExKey.minuteOffset)

            let endHourRange = match.range(at: TPDate.regExKey.endHourOffset)
            let endMinuteRange = match.range(at: TPDate.regExKey.endMinuteOffset)

            // Get arguments
            guard let year = extract(from: yearRange),
                let month = extract(from: monthRange),
                let day = extract(from: dayRange) else {
                    print("Missing YMD in <\(dateString)>")
                    return nil
            }
            self.init(year: year, month: month, day: day,
                      hour: extract(from: hourRange),
                      minute: extract(from: minuteRange),
                      endHour: extract(from: endHourRange),
                      endMinute: extract(from: endMinuteRange))
        }
        catch let error {
            print(error)
            return nil
        }
    }
}
