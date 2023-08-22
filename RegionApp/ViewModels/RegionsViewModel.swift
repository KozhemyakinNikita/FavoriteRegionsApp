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
    func toggleLike(for brand: Brand)
    func showLoader()
    func hideLoader()
}


class RegionViewModel {
    var isLoading = false
    
    weak var view: RegionListViewReload?
    private var regions: [Brand] = []
    
    
    
    
    func getList() async throws -> [Brand] {
        let urlSession = URLSession.shared
        guard let url = URL(string:"https://vmeste.wildberries.ru/api/guide-service/v1/getBrands") else {
            throw URLError(.badURL)
        }
        
        let requestURL = URLRequest(url: url)
        
        
        let (data, _) = try await urlSession.dataTask(for: requestURL)
        let region = try JSONDecoder().decode(Region.self, from: data)
        //        print(region.brands)
        return region.brands
    }
    
}

extension RegionViewModel: RegionViewModelProtocol {
    
    var numberOfRegions: Int {
        return regions.count
    }
    
    func showLoader() {
        isLoading = true
        view?.showLoader()
    }
    
    func hideLoader() {
        isLoading = false
        view?.hideLoader()
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
                    self?.view?.reloadData()
                }
            } catch {
                hideLoader()
                print("Error loading data")
            }
        }
    }
    
    func toggleLike(for brand: Brand) {
        if let index = regions.firstIndex(where: { $0.brandID == brand.brandID }) {
            regions[index].isLiked.toggle()
        }
    }
}
