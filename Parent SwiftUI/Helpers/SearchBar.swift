//
//  SearchBar.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    
    @State private var isEditing = false

     var body: some View {
         TextField("Search in subjects...", text: $searchText)
             .padding(8)
             .padding(.horizontal, 35)
             .background(.white)
             .foregroundColor(.black.opacity(0.3))
             .font(.system(size: 16))
             .autocapitalization(UITextAutocapitalizationType.none)
             .cornerRadius(10)
             .onTapGesture {
                 self.isEditing = true
             }
             .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black.opacity(0.3))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 20))
                        .padding(.leading, 15)
                    
                    if isEditing {
                        Button(action: {
                            self.isEditing = false
                            self.searchText = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.black.opacity(0.3))
                                .padding(.trailing, 15)
                        }
                    }
                }
             
             )
     }
}

