//
//  DetailRegionsViewModel.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 23.08.2023.
//

import Foundation

//MARK: - class DetailRegionsViewModel

class DetailRegionsViewModel {
    private let region: Brand
    weak var delegate: RegionTableViewCellDelegate?
    private let index: Int
    var isLiked = false
    
    init(region: Brand, index: Int) {
        self.region = region
        self.index = index
        isLiked = region.isLiked
    }
    
    var title: String {
        return region.title
    }
    
    var imageUrls: [URL] {
        return region.thumbUrls.compactMap { URL(string: $0) }
    }
    
    var viewsCount: Int {
        return region.viewsCount
    }
    
    func toggleLike(isLiked: Bool) {
        delegate?.didToggleLikeFromDetailVC(for: index, isLiked: isLiked)
    }
}
