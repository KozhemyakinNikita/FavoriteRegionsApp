//
//  RegionsModel.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation

// MARK: - Region
struct Region: Codable {
    let brands: [Brand]
}

// MARK: - Brand
struct Brand: Codable {
    let brandID, title: String
    let thumbUrls: [String]
    let tagIDS: [String]
    let slug, type: String
    var viewsCount: Int
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case brandID = "brandId"
        case title, thumbUrls
        case tagIDS = "tagIds"
        case slug, type, viewsCount
    }
}
