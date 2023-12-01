//
//  ContentView.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var debouncer: TextDebouncer = .init()
  @StateObject var searchState: FlickrSearch.State = .init()
  @State var text: String = ""
  
  var body: some View {
    NavigationStack {
      VStack (spacing: 8) {
        HStack {
          Spacer()
          Text("Flicker Browser")
          Spacer()
        }
        Divider()
        FlickrSearch(state: searchState)
        Spacer()
      }.padding(.horizontal, 16)
    }.searchable(text: $debouncer.text).onAppear {
      debouncer.startDebounce(update: searchState.search(_:))
    }
  }
  
  func updateText(_ text: String) {
    self.text = text
  }
}
#Preview {
  ContentView()
}
