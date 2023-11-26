//
//  FlickerSearchResults.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//

import SwiftUI

struct FlickerSearchResults: View {
  let cards: [FlickrCard]
  @State var selectedCard: FlickrCard?
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
        ForEach(cards) { card in
          AsyncImage(url: card.thumbnail).sheet(item: $selectedCard, content: FlickrDetails.init(card: ))
        }
      }
    }
  }
}

struct FlickrDetails: View {
  let card: FlickrCard
  
  var body: some View {
    Text("Title: \(card.title)")
  }
}

struct FlickrCard: Identifiable {
  let id: UUID = .init()
  let title: String
  let height: Int
  let width: Int
  let thumbnail: URL
  let image: URL
  let date: Date
}
