//
//  TRCItem.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

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
