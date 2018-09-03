//
//  TPItem.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import Foundation

enum TPItem {
    case project(String)
    case task(String)
    case text(String)
}

extension TPItem {
    var value: String {
        switch self {
        case .project(let text):
            return text
        case .task(let text):
            return text
        case .text(let text):
            return text
        }
    }
}

extension TPItem: CustomStringConvertible {
    var description: String {
        switch self {
        case .project:
            return value + ":"
        case .task:
            return "- " + value
        case .text:
            return value
        }
    }
}
