//
//  APIs.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

// ------------------------------------ API LIST ------------------------------------ //

let TEACHER_PATH = "https://api.my-educare.com/teacher_api/"
let GENERAL_PATH = "https://api.my-educare.com/general_api/"
let PARENT_PATH = "https://api.my-educare.com/parent_api/"
let STUDENT_PATH = "https://api.my-educare.com/student_api/"

// LOGIN-LOGOUT
let URL_USER_LOGIN = GENERAL_PATH + "login.php"
let URL_GET_COUNTRY = GENERAL_PATH + "country_codes.php"
let URL_USER_LOGOUT = GENERAL_PATH + "logout.php"

let URL_GET_BADGE_COUNTERS = PARENT_PATH + "parent_get_badge_counters.php"
let URL_RESET_BADGES = PARENT_PATH + "parent_reset_badge_counter.php"

// GET CHILDREN
let URL_GET_CHILDREN = PARENT_PATH + "get_child.php"

// FEEDBACK
let URL_SEND_FEEDBACK = GENERAL_PATH + "send_feedback_form.php"

// MODULE BANS
let URL_GET_BANNED_MODULES = STUDENT_PATH + "check_module_bans_student.php"

// SEMESTER
let URL_GET_SEMESTERS = PARENT_PATH + "get_semester.php"

// TEACHERS LIST
let URL_GET_TEACHERS_LIST = PARENT_PATH + "_parent_get_teachers_list.php"

// EMAIL
let URL_GET_EMAIL = PARENT_PATH + "_parent_get_emails.php"
let URL_GET_SINGLE_EMAIL = PARENT_PATH + "parent_get_single_email.php"
let URL_REPLY_EMAIL = PARENT_PATH + "reply_to_email.php"

//T RACKING
let URL_GET_COURSES_FOR_CHILD = PARENT_PATH + "get_courses_for_child.php"
let URL_GET_TRACKING_OBJECTIVES = PARENT_PATH + "get_tracking_objectives.php"
let URL_GET_TRACKING_HISTORY = PARENT_PATH + "get_tracking_history_for_student.php"

// CLUBS
let URL_GET_CLUBS_LIST = PARENT_PATH + "_parent_get_clubs_list.php"
let URL_GET_SEMESTER_FOR_CLUB = PARENT_PATH + "get_semester_for_club.php"
let URL_REGISTER_TO_CLUB = PARENT_PATH + "parent_register_to_club.php"
let URL_GET_CLUB_INFO = PARENT_PATH + "parent_get_club_info.php"

// BEHAVIOR
let URL_GET_BEHAVIORS = TEACHER_PATH + "get_student_behaviours.php"

// ATTENDANCE
let URL_GET_ATTENDANCES = PARENT_PATH + "parent_get_student_attendances.php"

// DAILY REPORT
let URL_GET_DAILY_REPORTS = PARENT_PATH + "_parent_get_daily_report.php"

// COMMENTS
let URL_GET_COMMENTS = PARENT_PATH + "parent_get_student_comments.php"
let URL_GET_SINGLE_COMMENT = PARENT_PATH + "parent_get_single_comment.php"

// HOMEWORK
let URL_GET_HOMEWORKS = PARENT_PATH + "parent_get_student_homeworks.php"
let URL_GET_SINGLE_HOMEWORK = PARENT_PATH + "parent_get_single_homework.php"
let URL_UPLOAD_FILE = PARENT_PATH + "upload_my_work.php"

// GRADES
let URL_GET_GRADES = PARENT_PATH + "parent_get_student_grades.php"

// TIMETABLE
let URL_GET_TIMETABLE = PARENT_PATH + "_parent_get_student_timetable.php"

// MESSAGING
let URL_GET_MESSAGES = PARENT_PATH + "_parent_get_inapp_message.php"
let URL_SEND_MESSAGE =  PARENT_PATH + "parent_write_message.php"
let URL_DELETE_MESSAGE = TEACHER_PATH + "teacher_delete_message.php"
let URL_GET_MESSAGE_COUNTER = PARENT_PATH + "parent_message_counter.php"
let URL_RESET_MESSAGE_COUNTER = TEACHER_PATH + "teacher_reset_message_counter.php"

// EXAM DATES
let URL_GET_EXAM_DATES = STUDENT_PATH + "get_exam_dates.php"

// NURSERY PROGRESS REPORT
let URL_GET_NURSERY_PROGRESS = PARENT_PATH + "get_nursery_progress.php"

// GDPR
let URL_GET_GDPR_RULES = PARENT_PATH + "get_gdpr_rules.php"
let URL_SEND_GDPR_FORM = PARENT_PATH + "send_gdpr_form.php"
let URL_GET_GDPR_EDUCATIONAL_YEARS = PARENT_PATH + "get_gdpr_educational_years.php"

// READING
let URL_GET_STUDENT_BOOK_LIST = PARENT_PATH + "get_student_book_list.php"

// DEBITS
let URL_GET_DEBTS = PARENT_PATH + "_parent_get_debts.php"
let URL_GET_INSTALLMENTS = PARENT_PATH + "_parent_get_installments.php"
let URL_GET_EXCHANGE_RATE = PARENT_PATH + "get_exchange_rate.php"
let URL_GET_PAYMENT_URL = PARENT_PATH + "payment_get_url.php"
let URL_EDUCATIONAL_YEARS = PARENT_PATH + "_parent_get_list_of_educational_years.php"

// DAILY SUMMARY
let URL_GET_DAILY_SUMMARY = PARENT_PATH + "get_daily_summary.php"
let URL_GET_FEEDBACK_DAILY_SUMMARY = PARENT_PATH + "get_feedback_daily_summary.php"
let URL_SEND_DAILY_SUMMARY_FEEDBACK = PARENT_PATH + "send_feedback_daily_summary.php"

// APPOINTMENT
let URL_TEACHER_LIST_APPOINTMENT = PARENT_PATH + "_parent_get_teacher_list_for_appointment.php"
let URL_APPOINTMENTS_OF_TEACHER = PARENT_PATH + "get_teacher_hours_for_appointment.php"
let URL_BOOK_APPOINTMENT = PARENT_PATH + "book_appointment.php"
let URL_CANCEL_APPOINTMENT = PARENT_PATH + "cancel_appointment.php"
let URL_GET_TEACHER_AVAILABLE_HOURS_APPOINTMENT = PARENT_PATH + "get_teacher_available_times_appointment.php"

// PARENT MEETING
let URL_DO_I_HAVE_MEETING = PARENT_PATH + "_parent_do_i_have_meeting.php"
let URL_GET_MEETING_DAYS = PARENT_PATH + "_parent_get_meetings.php"
let URL_GET_TEACHER_MEETING_TIMES = PARENT_PATH + "_parent_get_teachers_bookings.php"
let URL_BOOK_MEETING = PARENT_PATH + "parent_book_the_meeting.php"
let URL_CANCEL_MEETING = PARENT_PATH + "parent_cancel_meeting.php"

// EDU-SOCIAL
let URL_GET_EDUSOCIAL_POSTS = TEACHER_PATH + "get_edusocial_posts.php"
let URL_EDUSOCIAL_LIKE_POST = PARENT_PATH + "edusocial_like.php"
let URL_EDUSOCIAL_UNLIKE_POST = PARENT_PATH + "edusocial_unlike.php"
let URL_GET_EDUSOCIAL_LIKES = PARENT_PATH + "get_edusocial_likes.php"
