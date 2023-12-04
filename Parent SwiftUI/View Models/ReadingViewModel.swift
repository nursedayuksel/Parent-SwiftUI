//
//  ReadingViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire

class ReadingViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var books: [Books] = []
    
    private var booksArray: NSArray = []
    
    func getBookList() {
        let parameters: Parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "student_idx": studentIdx
        ]
        
        AF.request(URL_GET_STUDENT_BOOK_LIST, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                self.booksArray = dict.value(forKey: "data") as! NSArray
                
                if error == 0 {
                    self.books = []
                    
                    for obj in self.booksArray {
                        let singleBook = obj as! NSDictionary
                        
                        let bookName = singleBook.value(forKey: "book_name") as? String ?? ""
                        let date = singleBook.value(forKey: "date") as? String ?? ""
                        let description = singleBook.value(forKey: "description") as? String ?? ""
                        let star = singleBook.value(forKey: "star") as? String ?? ""
                        let pages = singleBook.value(forKey: "page") as? String ?? ""
                        let targetMonth = singleBook.value(forKey: "target_month") as? String ?? ""
                        let targetSession = singleBook.value(forKey: "target_session") as? String ?? ""
                        let test = singleBook.value(forKey: "test") as? String ?? ""
                        let sheet = singleBook.value(forKey: "sheet") as? String ?? ""
                        let project = singleBook.value(forKey: "project") as? String ?? ""
                        let drawing = singleBook.value(forKey: "drawing") as? String ?? ""
                        
                        let oneBook = Books(bookName: bookName, date: date, pages: pages, stars: star, description: description, targetMonth: targetMonth, targetSession: targetSession, test: test, sheet: sheet, project: project, drawing: drawing)
                        
                        self.books.append(oneBook)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
