//
//  RegionsViewModel.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation

protocol RegionListViewReload: AnyObject {
    func reloadData()
    func showLoader()
    func hideLoader()
}

protocol RegionViewModelProtocol: AnyObject {
    var numberOfRegions: Int { get }
    func region(at index: Int) -> Brand
    func fetchRegions()
    func showLoader()
    func hideLoader()
    func didTapLikeVC(isLiked: Bool, at index: Int)
}

class RegionViewModel {
    var isLoading = false
    
    weak var loadingDelegate: RegionListViewReload?
    private var regions: [Brand] = []
    
    func getList() async throws -> [Brand] {
        let urlSession = URLSession.shared
        guard let url = URL(string:"https://vmeste.wildberries.ru/api/guide-service/v1/getBrands") else {
            throw URLError(.badURL)
        }
        
        let requestURL = URLRequest(url: url)
        let (data, _) = try await urlSession.dataTask(for: requestURL)
        let region = try JSONDecoder().decode(Region.self, from: data)
        
        return region.brands
    }
}

extension RegionViewModel: RegionViewModelProtocol {
    
    var numberOfRegions: Int {
        return regions.count
    }
    
    func showLoader() {
        isLoading = true
        loadingDelegate?.showLoader()
    }
    
    func hideLoader() {
        isLoading = false
        loadingDelegate?.hideLoader()
    }
    
    func region(at index: Int) -> Brand {
        return regions[index]
    }
    
    func fetchRegions() {
        Task {
            do {
                self.showLoader()
                let regions = try await getList()
                DispatchQueue.main.async { [weak self] in
                    self?.regions = regions
                    self?.hideLoader()
                    self?.loadingDelegate?.reloadData()
                }
            } catch {
                hideLoader()
                print("Error loading data")
            }
        }
    }
    
    func didTapLikeVC(isLiked: Bool, at index: Int) {
        regions[index].isLiked = isLiked
        print("isLikedViewModel: \(regions[index].title) - \(regions[index].isLiked)")
    }
}
