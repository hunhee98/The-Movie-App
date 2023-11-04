//
//  Similar.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/21.
//

import Foundation

// MARK: - Similar
struct Similar: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
