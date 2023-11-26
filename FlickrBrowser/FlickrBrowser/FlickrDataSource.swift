//
//  FlickrDataSource.swift
//  FlickrBrowser
//
//  Created by Andrew Tillman on 11/25/23.
//

import Foundation

class FlickrDataSource {
  func searchFlickr(_ searchTerms: String) async throws -> [FlickrCard] {
    let json = try await fetchJSON(searchTerms)
    guard let items = json["items"] as? [[String: Any]] else {
      throw jsonError(description: "Missing items field")
    }
    return items.compactMap { item in
      guard let media = item["media"] as? [String: Any],
            let imageURL = media["m"] as? String,
            let image = URL(string: imageURL),
            let dateString = item["date_taken"] as? String,
            let date = isoDateFormatter.date(from: dateString)
      else {     
        return nil
      }
      return .init(
        image: image, 
        title: item["title"] as? String ?? "",
        height: 0,
        width: 0,
        date: date
      )
    }
  }
  
  private func fetchJSON(_ searchTerms: String) async throws -> [String: Any] {
    guard let url = searchURL(searchTerms) else {
      throw NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
        return jsonDictionary
      } else {
        throw jsonError()
        }
    } catch {
      throw error
    }
  }
}


fileprivate func searchURL(_ searchTerms: String) -> URL? {
  URL(string:"https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(searchTerms)")
}


fileprivate func jsonError(
  domain: String = "JSONParsingError",
  description: String = "JSON parsing error"
) -> NSError {
  return NSError(domain: domain, code: 0, userInfo: [NSLocalizedDescriptionKey: description])
}


let isoDateFormatter = ISO8601DateFormatter()
