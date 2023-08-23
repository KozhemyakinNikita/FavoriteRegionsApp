//
//  DetailRegionsViewModel.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 23.08.2023.
//

import Foundation

class DetailRegionsViewModel {
    private let region: Brand
    weak var delegate: RegionTableViewCellDelegate?
    private let index: Int
    var isLikedStatus = false
    
    init(region: Brand, index: Int) {
        self.region = region
        self.index = index
    }
    
    var title: String {
        return region.title
    }
    
    var imageUrl: URL? {
        return URL(string: region.thumbUrls.first ?? "")
    }
    
    var viewsCount: Int {
        return region.viewsCount
    }
    
    var isLiked: Bool {
        return region.isLiked
    }
    
    
    func toggleLike(isLiked: Bool) {
        
//        delegate?.didToggleLike(for: index, isLiked: isLiked)
    }
}
