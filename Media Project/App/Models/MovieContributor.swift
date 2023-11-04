//
//  MovieContributor.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import Foundation

// MARK: - MovieContributor
struct MovieContributor: Codable {
  let id: Int
  let cast, crew: [Cast]
}

// MARK: - Cast
struct Cast: Codable {
  let adult: Bool
  let gender, id: Int
  let name, originalName: String
  let popularity: Double
  let profilePath: String?
  let castID: Int?
  let character: String?
  let creditID: String
  let order: Int?
  let department: String?
  let job: String?
  
  enum CodingKeys: String, CodingKey {
    case adult, gender, id
    case name
    case originalName = "original_name"
    case popularity
    case profilePath = "profile_path"
    case castID = "cast_id"
    case character
    case creditID = "credit_id"
    case order, department, job
  }
  
  enum Role {
    case cast
    case crew
  }
  
  var profileImageURL: String? {
    guard let profilePath else { return nil}
    return MovieAPIManager.imageCDN + profilePath
  }
  
  var role: Role {
    character != nil ? .cast : .crew
  }
}
