//
//  Genres.swift
//  Media Project
//
//  Created by walkerhilla on 11/8/23.
//
//
import Foundation

// MARK: - Genres
struct Genres: Decodable {
  let genres: [Genre]
}

// MARK: - Genre
struct Genre: Decodable, Hashable {
  let id: Int
  let name: String

  static func == (lhs: Genre, rhs: Genre) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
