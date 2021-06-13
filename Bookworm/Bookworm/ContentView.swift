//
//  ContentView.swift
//  Bookworm
//
//  Created by Jessie Chen on 8/6/2021.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books:
        FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(books, id: \.self){ book in
                    NavigationLink(destination: DetailView(book:book)) {
                        EmojiRatingView(rating: book.rating).font(.largeTitle)
                    
                    
                    VStack(alignment: .leading) {
                        
                        if Int(book.rating) == 1 {
                            Text(book.title ?? "Unknown title").font(.headline).foregroundColor(Color(.red))
                        } else {
                            Text(book.title ?? "Unknown title").font(.headline)}
                        Text(book.author ?? "Unknown author").foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteBook)
                
            }
                .navigationTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: { self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                }
                )
                .sheet(isPresented: $showingAddScreen){
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }
    }

    func deleteBook(at offsets: IndexSet){
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
