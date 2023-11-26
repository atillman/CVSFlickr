//
//  ContentView.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var debouncer: TextDebouncer = .init()
  @State var text: String = ""
  
  var body: some View {
    VStack (spacing: 8) {
      HStack {
        Spacer()
        Text("Flicker Browser")
        Spacer()
      }
      Divider()
      TextField("Search", text: $debouncer.text)
        .submitLabel(.return)
        .padding(8)
        .foregroundColor(.black)
        .background(Color.gray)
        .cornerRadius(10)
        .padding()
      Divider()
      Text("The text is: \(text)")
      Spacer()
      
    }.padding(.horizontal, 16).onAppear {
      debouncer.startDebounce(update: updateText(_:))
    }
  }
  
  func updateText(_ text: String) {
    self.text = text
  }
}
#Preview {
  ContentView()
}
