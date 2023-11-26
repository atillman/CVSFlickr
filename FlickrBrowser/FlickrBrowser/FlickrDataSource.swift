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
            let date = isoDateFormatter.date(from: dateString),
            let description = item["description"] as? String,
            let widthAndHeight = extractWidthAndHeight(from: description)
      else {
        return nil
      }
      return .init(
        image: image, 
        title: item["title"] as? String ?? "",
        height: widthAndHeight.height ?? 0,
        width: widthAndHeight.width ?? 0,
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

fileprivate func extractWidthAndHeight(from htmlString: String) -> (width: Int?, height: Int?)? {
  let widthPattern = "width=\"(\\d+)\""
  let heightPattern = "height=\"(\\d+)\""

  do {
    let widthRegex = try NSRegularExpression(pattern: widthPattern)
    let heightRegex = try NSRegularExpression(pattern: heightPattern)

    let widthMatches = widthRegex.matches(in: htmlString, range: NSRange(htmlString.startIndex..., in: htmlString))
    let heightMatches = heightRegex.matches(in: htmlString, range: NSRange(htmlString.startIndex..., in: htmlString))

    if let widthMatch = widthMatches.first, let heightMatch = heightMatches.first {
      if let widthRange = Range(widthMatch.range(at: 1), in: htmlString),
         let heightRange = Range(heightMatch.range(at: 1), in: htmlString) {
        
        let widthString = String(htmlString[widthRange])
        let heightString = String(htmlString[heightRange])
        

        return (width: Int(widthString), height: Int(heightString))
      }
    }
  } catch {
    print("Error geting heigh and widge \(error.localizedDescription)")
  }
  
  return nil
}


let isoDateFormatter = ISO8601DateFormatter()
