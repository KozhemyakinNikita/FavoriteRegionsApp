//
//  RegionsViewModel.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation

//MARK: - Protocols

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
    func didOpenRegion(at index: Int)
}

//MARK: - class RegionViewModel

class RegionViewModel {
    
    // MARK: - Properties
    
    var isLoading = false
    
    weak var loadingDelegate: RegionListViewReload?
    private var regions: [Brand] = []
    
    // MARK: - Public functions
    
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

//MARK: - Extentions

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
                    print("Successful loading data")
                }
            } catch {
                hideLoader()
                print("Error loading data")
            }
        }
    }
    
    func didTapLikeVC(isLiked: Bool, at index: Int) {
        regions[index].isLiked = isLiked
        //        print("isLikedViewModel: \(regions[index].title) - \(regions[index].isLiked)")
    }
    
    func didOpenRegion(at index: Int) {
            regions[index].viewsCount += 1
        }
}
