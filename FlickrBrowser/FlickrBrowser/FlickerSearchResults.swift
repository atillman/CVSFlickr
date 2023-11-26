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
      LazyVStack {
        ForEach(cards) { card in
          AsyncImage(url: card.image).sheet(item: $selectedCard, content: FlickrDetails.init(card: )).onTapGesture {
            selectedCard = card
          }
        }
      }
    }
  }
}

struct FlickrDetails: View {
  let card: FlickrCard
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Spacer()
        AsyncImage(url: card.image)
        Spacer()
      }.padding(.bottom, 10)
      Divider()
      Text("Title: \(card.title)")
      Text("Height: \(card.height), Width: \(card.width)")
      Text("Posted: \(card.relateiveDate)")
      Spacer()
    }.padding(.horizontal, 16).padding(.vertical, 20)
  }
}

struct FlickrCard: Identifiable {
  let id: UUID = .init()
  let image: URL
  let title: String
  let height: Int
  let width: Int
  let date: Date
  
  var relateiveDate: String {
    relativeDateFormatter.localizedString(for: date, relativeTo: .now)
  }
}

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()
