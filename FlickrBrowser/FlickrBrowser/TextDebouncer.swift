//
//  TextDebouncer.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//
import Foundation
import Combine
import SwiftUI

class TextDebouncer: ObservableObject {
  @Published var text: String = ""
  private var debounceCancel: AnyCancellable?
  
  init() {}
  
  func startDebounce(update: @escaping TextDebounceUpdate) {
    debounceCancel = $text.debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
      .sink(receiveValue: update)
  }
}

typealias TextDebounceUpdate = (String) -> Void
