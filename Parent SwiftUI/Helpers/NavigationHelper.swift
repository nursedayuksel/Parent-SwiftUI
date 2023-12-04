//
//  NavigationHelper.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import SwiftUI

struct NavigationHelper {
    @ViewBuilder
    func navigateToModules(moduleName: String) -> some View {
        switch moduleName {
        case "Timetable":
            TimeTableView()
        case "Grades":
            GradesView()
        case "Attendance":
            AttendanceView()
        case "Comments":
            CommentsView()
        case "Homework":
            HomeworkView()
        case "Daily Reports":
            DailyReportsView()
        case "E-mails":
            EmailView()
        case "Debits":
            DebitView()
        case "Clubs":
            ClubsView()
        case "Messaging":
            MessagingView()
        case "Parents' Meeting":
            ParentMeetingView()
        case "Appointment":
            AppointmentView()
        case "Behaviour":
            BehaviourView()
        case "Daily Summary":
            DailySummaryView()
        case "Tracking":
            TrackingView()
        case "Nursery Report":
            NurseryReportView()
        case "Exam Dates":
            ExamDatesView()
        case "GDPR":
            GDPRView()
        case "Reading":
            ReadingView()
        case "Edu-Social":
            EduSocialView()
        default:
            EmptyView()
        }
    }
}

extension NavigationHelper {
    func handleDeepLink(_ deeplink: DeepLink) -> String {
        switch deeplink {
        case .messaging:
            "Messaging"
        case .email:
            "E-mails"
        }
    }
}
