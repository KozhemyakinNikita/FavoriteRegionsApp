//
//  CerouselCollectionViewCell.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 23.08.2023.
//

import UIKit
import SDWebImage

class CarouselCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CarouselCollectionViewCell"
    
    var regionPicture: UIImageView = {
        let picture = UIImageView()
        picture.layer.cornerRadius = 16
        picture.clipsToBounds = true
        picture.contentMode = .scaleAspectFill
        //        picture.backgroundColor = .red
        return picture
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        layer.shadowRadius = 10
        //        layer.shadowOpacity = 0.7
        //        layer.shadowOffset = CGSize(width: 8, height: 8)
        //        layer.shadowColor = UIColor.darkGray.cgColor
        //        self.clipsToBounds = false
        
        self.dropShadow(color: .darkGray, opacity: 1, offSet: CGSize(width: 4, height: 4), radius: 5)
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
}
