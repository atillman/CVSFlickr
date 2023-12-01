//
//  FlickrSearch.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//

import SwiftUI

struct FlickrSearch: View {
  @ObservedObject var state: State
  
  var body: some View {
    Group {
      switch state.status {
      case .empty:
        Text("Enter search text browse Flickr")
      case .searching:
        ProgressView().progressViewStyle(.circular)
      case .results(let cards):
        FlickerSearchResults(cards: cards)
      case .error(let error):
        Text("Error searching; \(error.localizedDescription)").foregroundColor(.red)
      }
    }
  }
}

extension FlickrSearch {
  class State: ObservableObject {
    let dataSource: FlickrDataSource = .init()
    @Published var status: Status = .empty
    private var currentSearch: String?
    
    init() {}
  }
}

extension FlickrSearch.State {
  enum Status {
    case empty
    case searching
    case results([FlickrCard])
    case error(Error)
  }
}

extension FlickrSearch.State {
  func search(_ searchTerms: String) {
    guard searchTerms != currentSearch else {
      return
    }
    currentSearch = searchTerms
    
    guard !searchTerms.isEmpty else {
      status = .empty
      return
    }
    
    status = .searching
        
    Task {
      do {
        await self.updateCards(try await dataSource.searchFlickr(searchTerms))
      } catch {
        status = .error(error)
      }
    }
  }
  
  @MainActor
  private func updateCards(_ cards: [FlickrCard]) {
    status = .results(cards)
  }
}
