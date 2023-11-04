//
//  Placse.swift
//  Media Project
//
//  Created by walkerhilla on 2023/11/04.
//

import Foundation

// MARK: - Place
struct Place: Codable {
    let meta: Meta
    let ac: [String]
    let place: [PlaceElement]
    let all: [All]
}

// MARK: - All
struct All: Codable {
    let place: PlaceElement
}

// MARK: - PlaceElement
struct PlaceElement: Codable {
    let type: String
    let id, title, x, y: String
    let dist, totalScore: Double
    let sid: String
    let ctg: String
    let cid, jibunAddress, roadAddress: String
    let shortAddress: [String]
    let review: Review
}

// MARK: - Review
struct Review: Codable {
    let count: String
}

// MARK: - Meta
struct Meta: Codable {
  let model, query, requestId: String
}
