//
//  TPDateAsClass.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import Foundation

class TPDateAsClass {
    let year: Int
    let month: Int
    let day: Int

    init?(year: Int, month: Int, day: Int) {
        guard TPDateAsClass.isValid(year: year) &&
            TPDateAsClass.isValid(month: month) &&
            TPDateAsClass.isValid(year: year, month: month, day: day) else {
                return nil
        }
        // Normalize year
        let normYear: Int
        if (00 <= year && year <= 99) {
            normYear = 2000 + year
        } else {
            normYear = year
        }
        self.year = normYear
        self.month = month
        self.day = day
    }

    // MARK: - Internal Constants
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

    // MARK: - Validation Functions
    class func isLeapYear(year: Int) -> Bool {
        if (year % 4 == 0 && year % 100 != 0) ||
            (year % 400 == 0) {
            return true
        }
        return false
    }
    class func isValid(year: Int) -> Bool {
        return year > 0 && year <= 9999
    }
    class func isValid(month: Int) -> Bool {
        return self.months.contains(month)
    }
    class func isValid(year: Int, month: Int, day: Int) -> Bool {
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

    class func isValid(hour: Int) -> Bool {
        return 0 <= hour && hour <= 23
    }

    class func isValid(minute: Int) -> Bool {
        return 0 <= minute && minute <= 59
    }
}

class TPReminder: TPDateAsClass {
    let hour: Int
    let minute: Int

    init?(year: Int, month: Int, day: Int, hour: Int, minute: Int) {
        guard TPDateAsClass.isValid(hour: hour) &&
            TPDateAsClass.isValid(minute: minute) else {
                return nil
        }
        self.hour = hour
        self.minute = minute
        super.init(year: year, month: month, day: day)
    }
}

class TPAppointment: TPReminder {
    let endHour: Int
    let endMinute: Int

    init?(year: Int, month: Int, day: Int,
          beginHour: Int, beginMinute: Int,
          endHour: Int, endMinute: Int) {
        guard TPDateAsClass.isValid(hour: endHour) &&
            TPDateAsClass.isValid(minute: endMinute) else {
                return nil
        }
        guard beginHour < endHour ||
            (beginHour == endHour &&
                beginMinute < endMinute) else {
                    return nil
        }
        self.endHour = endHour
        self.endMinute = endMinute

        super.init(year: year, month: month, day: day,
                   hour: beginHour, minute: beginMinute)
    }
}

// MARK: - Descriptions
extension TPDateAsClass {
    @objc var description: String {
        // YYYY-MM-DD
        return String(format: "%04d-%02d-%02d",
                      self.year, self.month, self.day)
    }
}

extension TPReminder {
    @objc override var description: String {
        // YYYY-MM-DD HH:MM
        let dateString = super.description
        return dateString + String(format: " %02d:%02d",
                                   self.hour, self.minute)
    }
}

extension TPAppointment {
    @objc override var description: String {
        // YYYY-MM-DD HH:MM-HH:MM
        let dateString = super.description
        return dateString + String(format:"-%02d:%02d",
                                   self.endHour, self.endMinute)
    }
}
