//
//  CarouselCollectionView.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 23.08.2023.
//

import UIKit
import SDWebImage

// MARK: - Protocols

protocol CarouselCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: CarouselCollectionView, didChangePageTo index: Int)
}

// MARK: - Constants
private enum Constants {
    static let leftDistanceToView: CGFloat = 8
    static let rightDistanceToView: CGFloat = 8
    static let minimumLineSpacingCells: CGFloat = 16
    static let carouselItemWidth: CGFloat = (UIScreen.main.bounds.width - Constants.leftDistanceToView - Constants.rightDistanceToView - Constants.minimumLineSpacingCells)
}

//MARK: - class CarouselCollectionView: UICollectionView

class CarouselCollectionView: UICollectionView  {
    var detailViewModel: DetailRegionsViewModel?
    weak var delegateSwipe: CarouselCollectionViewDelegate?
    let cells = [Brand]()
    private var regions: [Brand] = []
    let carouselLayout = UICollectionViewFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: carouselLayout)
        setupLayout()
        delegate = self
        dataSource = self
        register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.sectionInset = .init(top: 0, left: Constants.leftDistanceToView, bottom: 0, right: Constants.rightDistanceToView)
        carouselLayout.minimumLineSpacing = Constants.minimumLineSpacingCells
        clipsToBounds = true
        isPagingEnabled = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let currentPage = Int(x / frame.width)
        delegateSwipe?.collectionView(self, didChangePageTo: currentPage)
    }
    
}

// MARK: - Extentions

extension CarouselCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailViewModel?.imageUrls.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.reuseIdentifier, for: indexPath) as? CarouselCollectionViewCell
        else { return UICollectionViewCell() }
        
        let imageURL = detailViewModel?.imageUrls[indexPath.row]
        cell.regionPicture.sd_setImage(with: imageURL)
        return cell
    }
    
}

extension CarouselCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.carouselItemWidth, height: frame.height * 0.9)
    }
}
