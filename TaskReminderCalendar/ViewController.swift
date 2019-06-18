//
//  ViewController.swift
//  TaskReminderCalendar
//
//  Created by Jp LaFond on 9/2/18.
//  Copyright © 2018 Jp LaFond. All rights reserved.
//

import EventKit
import UIKit

class ViewController: UIViewController {
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let project = TPItem.project("Project")
        let task = TPItem.task("Task to do something")
        let text = TPItem.text("Text")

        let emptyTag = TPTag(name: "empty")
        let valueTag = TPTag(name: "value", value: "value")
        let dateTag = TPTag(name: "date", value: "2019-02-01")
        let reminderTag = TPTag(name: "reminder", value: "2019-02-01 08:04")
        let appointmentTag = TPTag(name: "appointment", value: "2019-02-01 08:04-14:06")

        let projectTRCI = TRCItem(indentBy: 0, item: project)
        let task1TRCI = TRCItem(indentBy: 1, item: task, tags: nil, parent: projectTRCI)
        let task2TRCI = TRCItem(indentBy: 1, item: task, tags: [], parent: projectTRCI)
        let task3TRCI = TRCItem(indentBy: 1, item: task, tags: [emptyTag, valueTag, dateTag, reminderTag, appointmentTag], parent: projectTRCI)
        let textTRCI = TRCItem(indentBy: 2, item: text, parent: task3TRCI)
        
        let task4aTRCI = TRCItem(indentBy: 2, item: task, tags: [dateTag], parent: task3TRCI)
        let task4bTRCI = TRCItem(indentBy: 2, item: task, tags: [reminderTag], parent: task3TRCI)
        let task4cTRCI = TRCItem(indentBy: 2, item: task, tags: [appointmentTag], parent: task3TRCI)

        print(projectTRCI)
        print(task1TRCI)
        print(task2TRCI)
        print(task3TRCI)
        print(textTRCI)
        
//        checkEKAuth(for: .event)
//        checkEKAuth(for: .reminder)
        let reminder = task4bTRCI.reminder
        let eventA = task4cTRCI.event
        let eventB = task4aTRCI.event
        
        print("Reminder <\(reminder)>")
        print("EventA <\(eventA)>")
        print("EventB <\(eventB)>")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkEKAuth(for entityType: EKEntityType) {
        let status = EKEventStore.authorizationStatus(for: entityType)
        switch status {
        case .notDetermined:
            // Request access
            print("Requesting access for <\(entityType)>")
            requestAccess(for: entityType)
        case .restricted,
             .denied:
            print("Unable to access [\(status)]")
        case .authorized:
            print("Life is good, adding <\(entityType)>")
            switch entityType {
            case .event:
                addEvent()
            case .reminder:
                addReminder()
            }
        }
    }
    
    func requestAccess(for entityType: EKEntityType) {
        eventStore.requestAccess(to: entityType) {
            (accessGranted, error) in
            
            if let error = error {
                print("[\(accessGranted ? "Granted" : "Not Granted")] Error <\(error)>")
            } else {
                print("[\(accessGranted ? "Granted" : "Not Granted")]")
            }
        }
    }

    func addEvent() {
//        guard let calendarToAddTo = eventStore.calendar(withIdentifier: "TPTest") else {
//            print("Could not create calendar")
//            return
//        }
        print("[\(eventStore.calendars(for: .event))]")
        
//        guard let calendarToAddTo = eventStore.calendars(for: .event).filter({$0.title == "TPTest"}).first else {
//            print("Could not create a calendar")
//            return
//        }
        let calendarToAddTo: EKCalendar
        if let tpTestCalendar = eventStore.calendars(for: .event).filter({$0.title == "TPTest"}).first {
            calendarToAddTo = tpTestCalendar
        } else {
            let tpTestCalendar = EKCalendar(for: .event, eventStore: eventStore)
            tpTestCalendar.title = "TPTest"
            tpTestCalendar.source = eventStore.sources.filter({$0.sourceType == EKSourceType.local}).first!
            do {
                try eventStore.saveCalendar(tpTestCalendar, commit: true)
                calendarToAddTo = tpTestCalendar
            }
            catch {
                print("Unable to save calendar <\(error)>")
                return
            }
        }
        let testEvent = EKEvent(eventStore: eventStore)
        testEvent.calendar = calendarToAddTo
        testEvent.title = "Test Event"
//        testEvent.startDate = Date()
//        testEvent.endDate = testEvent.startDate + 3600
//        testEvent.isAllDay = true
        testEvent.startDate = Date()
        testEvent.endDate = testEvent.startDate + (15 * 60)
        testEvent.notes = "This is a test."
        
//        do {
//            try eventStore.save(testEvent, span: .thisEvent)
//        }
//        catch {
//            print("Did not save <\(error)>")
//        }
        print("Event <\(testEvent)>")
    }
    
    func addReminder() {
//        guard let calendarToAddTo = eventStore.calendar(withIdentifier: "TPTest") else {
//            print("Could not create calendar")
//            return
//        }
        print("[\(eventStore.calendars(for: .reminder))]")
//        guard let calendarToAddTo = eventStore.calendars(for: .reminder).first else {
//            print("Could not create a calendar")
//            return
//        }
        let calendarToAddTo: EKCalendar
        if let tpTestCalendar = eventStore.calendars(for: .reminder).filter({$0.title == "TPTest"}).first {
            calendarToAddTo = tpTestCalendar
        } else {
            let tpTestCalendar = EKCalendar(for: .reminder, eventStore: eventStore)
            tpTestCalendar.title = "TPTest"
            tpTestCalendar.source = eventStore.sources.filter({$0.sourceType == EKSourceType.local}).first!
            do {
                try eventStore.saveCalendar(tpTestCalendar, commit: true)
                calendarToAddTo = tpTestCalendar
            }
            catch {
                print("Unable to save calendar <\(error)>")
                return
            }
        }
        let testReminder = EKReminder(eventStore: eventStore)
        testReminder.calendar = calendarToAddTo
        testReminder.title = "Test Reminder"
        testReminder.notes = "This is also a test"
        12
        
//        do {
//            try eventStore.save(testReminder, commit: true)
//        }
//        catch {
//            print("Did not save <\(error)>")
//        }
        print("Reminder <\(testReminder)>")
    }
    
}

