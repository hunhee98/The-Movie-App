//
//  Movie.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import Foundation

//struct Movie {
//  let id: Int
//  let title: String
//  let overView: String
//  let posterPath: String
//  let backdropPath: String
//  let releaseDate: String
//  let rate: Double
//  let adult: Bool
//
//  var posterImageURL: String {
//    MovieAPIManager.imageCDN + posterPath
//  }
//
//  var backdropImageURL: String {
//    MovieAPIManager.imageCDN + backdropPath
//  }
//}

struct Trending: Codable {
  let results: [Movie]
  let totalPages, page, totalResults: Int
  
  enum CodingKeys: String, CodingKey {
    case results
    case totalPages = "total_pages"
    case page
    case totalResults = "total_results"
  }
}

// MARK: - Result
struct Movie: Codable {
  let title: String
  let voteAverage: Double
  let voteCount: Int
  let originalLanguage: String
  let backdropPath: String?
  let originalTitle, releaseDate, overview: String
  let adult: Bool
  let posterPath: String
  let popularity: Double
  let genreIDS: [Int]
  let video: Bool
  let id: Int
  
  enum CodingKeys: String, CodingKey {
    case title
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case originalLanguage = "original_language"
    case backdropPath = "backdrop_path"
    case originalTitle = "original_title"
    case releaseDate = "release_date"
    case overview, adult
    case posterPath = "poster_path"
    case popularity
    case genreIDS = "genre_ids"
    case video, id
  }
  
  var posterImageURL: String {
    MovieAPIManager.imageCDN + posterPath
  }
  
  var backdropImageURL: String {
    MovieAPIManager.imageCDN + (backdropPath ?? "")
  }
}
