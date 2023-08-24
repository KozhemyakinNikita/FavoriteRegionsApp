//
//  CerouselCollectionViewCell.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 23.08.2023.
//

import UIKit
import SDWebImage

//MARK: - class CarouselCollectionViewCell: UICollectionViewCell

class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CarouselCollectionViewCell"
    
    var regionPicture: UIImageView = {
        let picture = UIImageView()
        picture.layer.cornerRadius = 16
        picture.clipsToBounds = true
        picture.contentMode = .scaleAspectFill
        return picture
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        regionPicture.addGestureRecognizer(tapGesture)
        regionPicture.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dropShadow(color: .darkGray, opacity: 1, offSet: CGSize(width: .zero, height: 0), radius: 6)
    }
    
    func setupUI() {
        addSubview(regionPicture)
        regionPicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regionPicture.leadingAnchor.constraint(equalTo: leadingAnchor),
            regionPicture.trailingAnchor.constraint(equalTo: trailingAnchor),
            regionPicture.topAnchor.constraint(equalTo: topAnchor),
            regionPicture.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc private func imageTapped() {
        if let image = regionPicture.image {
            let fullImageViewController = FullImageViewController(image: image)
            UIApplication.shared.keyWindow?.rootViewController?.present(fullImageViewController, animated: true, completion: nil)
        }
    }
}

