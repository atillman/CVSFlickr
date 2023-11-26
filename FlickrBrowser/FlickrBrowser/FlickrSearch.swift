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
        Text("Spinner")
      case .results(let text):
        Text("Searching for \(text)")
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
    
    init() {}
  }
}

extension FlickrSearch.State {
  enum Status {
    case empty
    case searching
    case results(String)
    case error(Error)
  }
}

extension FlickrSearch.State {
  func search(_ searchText: String) {
    guard !searchText.isEmpty else {
      status = .empty
      return
    }
    
    status = .searching
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      self.status = .results(searchText)
    }
  }
}
