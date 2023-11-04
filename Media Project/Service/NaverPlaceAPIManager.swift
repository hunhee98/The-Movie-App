//
//  NaverPlaceAPIManager.swift
//  Media Project
//
//  Created by walkerhilla on 2023/11/04.
//

import Foundation
import Alamofire
import SwiftyJSON

final class NaverPlaceAPIManager {
  static let shared = NaverPlaceAPIManager()
  private init() { }
  
  func callRequest<T: Codable>(type: Endpoint, responseType: T.Type, handler: @escaping (T?) -> ()) {
    let url = type.requestURL
    
    AF.request(url, method: .get).validate().responseDecodable(of: responseType) { response in
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

extension NaverPlaceAPIManager {
  static let baseURL = "https://map.naver.com/p/api/search/instant-search?query="

  enum Endpoint {
    case search((x: Double, y: Double))
    
    var requestURL: String {
      let baseURL = NaverPlaceAPIManager.baseURL
      let query = "영화관".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      switch self {
      case .search(let location): return baseURL + query + "&coords=\(location.x),\(location.y)"
      }
    }
  }
}
