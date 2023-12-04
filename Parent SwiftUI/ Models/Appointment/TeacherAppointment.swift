//
//  TeacherAppointment.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 25.04.2023.
//

import Foundation

struct TeacherAppointment: Decodable, Hashable {
    var teacherIdx: String
    var teacherName: String
    var hasAppointment: Bool
    var photo: String
    var startTimes: [String]
    var endTimes: [String]
    var intervals: [String]
    var appointedLocation: String
    var locations: [String]
    var location: String
    var link: String
    var weekdays: [String]
    var appTimeDate: String
    var isOnline: String
    var appDate: String
    var appTime: String
    
    init(teacherIdx: String, teacherName: String, photo: String, hasAppointment: Bool, weekdays: [String], appTimeDate: String, startTimes: [String], finishTimes: [String], intervals: [String], appointedLocation: String, locations: [String], location: String, link: String, isOnline: String, appDate: String, appTime: String)
    {
        self.teacherName = teacherName
        self.photo = photo
        self.hasAppointment = hasAppointment
        self.weekdays = weekdays
        self.appTimeDate = appTimeDate
        self.teacherIdx = teacherIdx
        self.startTimes = startTimes
        self.endTimes = finishTimes
        self.intervals = intervals
        self.appointedLocation = appointedLocation
        self.locations = locations
        self.location = location
        self.link = link
        self.isOnline = isOnline
        self.appDate = appDate
        self.appTime = appTime
    }
    
    func retTeacherName() -> String {
        return self.teacherName
    }
    
    func retTeacherPhoto() -> String
    {
        return self.photo
    }
    
    func retTeacherIdx() -> String
    {
        return self.teacherIdx
    }
    
    func appointmentStatus() -> Bool
    {
        return self.hasAppointment
    }
    
    mutating func setAppointmentStatus(status: Bool)
    {
        self.hasAppointment = status
    }

    mutating func appendWeekday(weekday: String)
    {
        weekdays.append(weekday)
    }
    
    mutating func appendStartTime(startTime: String)
    {
        startTimes.append(startTime)
    }
    
    mutating func appendFinsihTime(finishTime: String)
    {
        endTimes.append(finishTime)
    }
    
    mutating func appendInterval(interval: String)
    {
        intervals.append(interval)
    }
    
    mutating func appendLocation(location: String)
    {
        locations.append(location)
    }
}
