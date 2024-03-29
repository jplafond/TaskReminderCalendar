//
//  TRCItem.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import EventKit
import Foundation

class TRCItem {
    let indentBy: Int
    let item: TPItem
    let tags: [TPTag]?
    let parent: TRCItem?

    init(indentBy: Int,
         item: TPItem,
         tags: [TPTag]? = nil,
         parent: TRCItem? = nil) {
        self.indentBy = indentBy
        self.item = item
        self.tags = tags
        self.parent = parent
    }
}

extension TRCItem: CustomStringConvertible {
    var description: String {
        var text = ""
        (0..<indentBy).forEach{_ in
            text += "\t"
        }
        text += item.description
        guard let tags = tags,
            tags.count > 0 else {
            return text
        }
        tags.forEach {tag in
            text += " " + tag.description
        }
        return text
    }
}

// MARK: - Event Conversion
extension TRCItem {
    var reminder: EKReminder? {
        guard let tags = tags,
            !tags.isEmpty else {
                print("No tags")
                return nil
        }
        let tagDates = tags.filter({$0.date != nil})
        guard !tagDates.isEmpty else {
            print("No dates")
            return nil
        }
        for tagDate in tagDates {
            if let date = tagDate.date {
                switch date {
                case .reminder(_, _, _, _, _):
                    let title = self.item.value
                    let store = EKEventStore()
                    let reminder = EKReminder(eventStore: store)
                    reminder.title = title
                    reminder.dueDateComponents = date.startDateComponents
                    
                    return reminder
                default:
                    return nil
                }
            }
        }
        return nil
    }

    var event: EKEvent? {
        guard let tags = tags,
            !tags.isEmpty else {
                print("No tags")
                return nil
        }
        let tagDates = tags.filter({$0.date != nil})
        guard !tagDates.isEmpty else {
            print("No dates")
            return nil
        }
        for tagDate in tagDates {
            if let date = tagDate.date {
                switch date {
                case .date(_, _, _),
                     .appointment(_, _, _, _, _, _, _):
                    let title = self.item.value
                    let store = EKEventStore()
                    let event = EKEvent(eventStore: store)
                    event.title = title
                    event.startDate = date.startDate
                    if let endDate = date.endDate {
                        event.endDate = endDate
                    } else {
                        event.endDate = date.startDate
                        event.isAllDay = true
                    }
                    
                    return event
                default:
                    return nil
                }
            }
        }
        return nil
    }
}
