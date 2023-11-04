//
//  MovieAPIManager.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import Foundation
import Alamofire
import SwiftyJSON

final class MovieAPIManager {
  static let shared = MovieAPIManager()
  private init() { }
  
  func callRequest<T: Codable>(type: Endpoint, responseType: T.Type, handler: @escaping (T?) -> ()) {
    let url = type.requestURL
    let headers: HTTPHeaders = [
      "Authorization": APIKeys.theMovieDB
    ]
    
    AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: responseType) { response in
      switch response.result {
      case .success(let value):
        handler(value)
      case .failure(let error):
        print(error)
        handler(nil)
      }
    }
  }
}

extension MovieAPIManager {
  static let baseURL = "https://api.themoviedb.org/3/"
  static let imageCDN = "https://image.tmdb.org/t/p/original/"
  
  enum Endpoint {
    case trending(timeWindow)
    case credits(Int)
    case similar(Int)
    
    var requestURL: String {
      let baseURL = MovieAPIManager.baseURL
      switch self {
      case .trending(let tw): return baseURL + "trending/movie/" + tw.rawValue
      case .credits(let id): return baseURL + "movie/\(id)/credits"
      case .similar(let id): return baseURL + "movie/\(id)/similar"
      }
    }
    
    enum timeWindow: String {
      case day
      case week
    }
  }
}
