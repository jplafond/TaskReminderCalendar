//
//  TPTag.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import Foundation

enum TPTag {
    case empty(name: String)
    case value(name: String, value: String)
    case date(name: String, date: TPDate)

    init(name: String, value: String? = nil) {
        if let value = value {
            if let date = TPDate(dateString: value) {
                self = .date(name: name, date: date)
            } else {
                self = .value(name: name, value: value)
            }
        } else {
            self = .empty(name: name)
        }
    }
}

// MARK: - Accessor
extension TPTag {
    var name: String {
        switch self {
        case .empty(let name):
            return name
        case .value(let name, _):
            return name
        case .date(let name, _):
            return name
        }
    }

    var value: String? {
        switch self {
        case .date(_, let date):
            return date.description
        case .value(_, let value):
            return value
        case .empty:
            return nil
        }
    }

    var date: TPDate? {
        switch self {
        case .date(_, let date):
            return date
        default:
            return nil
        }
    }
}

extension TPTag: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:
            return "@\(name)"
        case .value, .date:
            return "@\(name)(\(value!))"
        }
    }
}
