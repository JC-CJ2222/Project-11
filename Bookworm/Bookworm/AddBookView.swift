//
//  AddBookView.swift
//  Bookworm
//
//  Created by Jessie Chen on 9/6/2021.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var date = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Name of the book", text:$title)
                    TextField("Author's name", text:$author)
                    
                    Picker("Genre", selection: $genre){
                        ForEach(genres, id: \.self){
                            Text($0)
                        }
                    }
                }
                
                Section{
                    RatingView(rating: $rating)
                    TextField("Write a Review", text:$review)
                }
                    
                Section{
                    Button("Save"){
                        
                        let currentDate = Date()
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        formatter.timeStyle = .short

//                        Text("\(currentDate, style: .date) \(currentDate, style: .time)")
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = formatter.string(from: currentDate)
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                }
            .navigationTitle("Add Book")
            }
        }
    }


struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
