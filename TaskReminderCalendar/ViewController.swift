//
//  ViewController.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let project = TPItem.project("Project")
        let task = TPItem.task("Task")
        let text = TPItem.text("Text")

        let emptyTag = TPTag(name: "Empty")
        let valueTag = TPTag(name: "Value", value: "value")
        let dateTag = TPTag(name: "Date", value: "2018-01-02")
        let reminderTag = TPTag(name: "Reminder", value: "2018-01-02 03:04")
        let appointmentTag = TPTag(name: "Appointment", value: "2018-01-02 03:04-05:06")

        let projectTRCI = TRCItem(indentBy: 0, item: project)
        let task1TRCI = TRCItem(indentBy: 1, item: task, tags: nil, parent: projectTRCI)
        let task2TRCI = TRCItem(indentBy: 1, item: task, tags: [], parent: projectTRCI)
        let task3TRCI = TRCItem(indentBy: 1, item: task, tags: [emptyTag, valueTag, dateTag, reminderTag, appointmentTag], parent: projectTRCI)
        let textTRCI = TRCItem(indentBy: 2, item: text, parent: task3TRCI)

        print(projectTRCI)
        print(task1TRCI)
        print(task2TRCI)
        print(task3TRCI)
        print(textTRCI)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

