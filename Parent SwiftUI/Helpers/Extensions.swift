//
//  Extensions.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import SwiftUI
import Alamofire

let lessonImages: NSArray =
    [
        ["theory", "idea-2"],
        ["educatie fizica" , "basketball"],
        ["matemat", "algebra"],
        ["math" , "algebra"],
        ["reading", "reading"],
        ["computer", "coding"],
        ["informatic", "coding"],
        ["science", "atom"],
        ["physics", "physics"],
        ["fizica", "physics"],
        ["english", "english-language"],
        ["engleza", "english-language"],
        ["history", "history"],
        ["istorie", "history"],
        ["turkish", "turkey"],
        ["turca", "turkey"],
        ["drama", "theater"],
        ["music", "music-notes"],
        ["geogra", "geography"],
        ["tehn", "laptop"],
        ["tech", "laptop"],
        ["astron", "telescope"],
        ["mindfullness", "idea"],
        ["dirigent", "teacher"],
        ["philosophy", "idea"],
        ["albania", "albania"],
        ["citizenship", "people"],
        ["plastic", "paint"],
        ["social", "people"],
        ["spaniol", "spain"],
        ["antrepren", "graph"],
        ["arabic", "alif-512"],
        ["handwriting", "writing"],
        ["p.s.h.e", "teacher"],
        ["roman", "romania"],
        ["humanities", "people"],
        ["physical", "basketball"],
        ["ecolog","ecology"],
        ["psycho", "brain"],
        ["psihol", "brain"],
        ["econom", "graph"],
        ["literat", "papyrus"],
        ["exam", "test"],
        ["environment", "ecology"],
        ["ielts", "test"],
        ["tourism", "travel"],
        ["terbiýeçilik", "people"],
        ["taryhy", "history"],
        ["iňlis", "britain"],
        ["türkmen dili", "turkmenistan"],
        ["statist", "pie-chart"],
        ["theatre", "theater"],
        ["theater", "theater"],
        ["sociol", "people"],
        ["mandarin", "china"],
        ["joc si miscare", "slider"],
        ["muzica", "music-notes"],
        ["ora de studiu", "boy"],
        ["abilitati practice", "scissors"],
        ["ora de studi", "boy"],
        ["religi", "hand"],
        ["spanish", "spain"],
        ["computing", "coding"],
        ["golden time", "clock"],
        ["dezvoltare", "smile-2"],
        ["library", "books"],
        ["logic", "puzzle"],
        ["business", "graph"],
        ["global","worldwide"],
        ["geometr" , "shapes"],
        ["franceza" , "france"],
        ["french", "france"],
        ["german", "germany"],
        ["chimie", "chemistry"],
        ["chemistry", "chemistry"],
        ["biolog", "dna"],
        ["fizica", "physics"],
        ["latin", "books-2"],
        ["stiintele naturii", "sun"],
        ["ict", "coding"],
        ["art", "paint"],
        ["arte vizuale", "paint"],
        ["pe", "basketball"],
        ["tic", "coding"],
        ["esl", "conversation"],
        ["pshe", "teacher"],
        ["itgs","laptop"],
        ["no lesson", "smile"]
    ]

var randomImages = ["apple", "books-2", "books-3", "reading-book", "bell", "smile", "pencil"]

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.width
     }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
         let fontAttributes = [NSAttributedString.Key.font: font]
         let size = self.size(withAttributes: fontAttributes)
         return size.height
     }
}

// -- REMOVING DUPLICATES FROM AN ARRAY --
extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }

        // Scanner creation
        let scanner = Scanner(string: string)

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
}

extension ObservableObject {
    func resetBadge(table: String, studentIdx: String)
    {
        let defaults = UserDefaults.standard
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group" : defaults.string(forKey: "school_group")!,
            "table" : table,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]

        AF.request(URL_RESET_BADGES, method: .post, parameters: parameters).responseJSON{ response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                if dict.value(forKey: "error") as? Int == 0 {}
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension Date {
    func dateComponents(_ components: Set<Calendar.Component>, using calendar: Calendar = .current) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }
    
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        calendar.date(from: dateComponents([.yearForWeekOfYear, .weekOfYear], using: calendar))!
    }
    
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func byAdding(component: Calendar.Component, value: Int, wrappingComponents: Bool = false, using calendar: Calendar = .current) -> Date? {
        calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrappingComponents)
    }
    
    func daysOfWeek(using calendar: Calendar = .current) -> [Date] {
        let startOfWeek = self.startOfWeek(using: calendar).noon
        return (0...6).map { startOfWeek.byAdding(component: .day, value: $0, using: calendar)! }
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

func empty() -> Void {}

extension URL {
  var isDeeplink: Bool {
    return scheme == "my-url-scheme" // matches my-url-scheme://<rest-of-the-url>
  }

  var tabIdentifier: DeepLink? {
    guard isDeeplink else { return nil }

    switch host {
    case "email": return .email // matches my-url-scheme://home/
    case "messaging": return .messaging // matches my-url-scheme://settings/
    default: return nil
    }
  }
}
