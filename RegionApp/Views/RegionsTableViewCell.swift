//
//  RegionsTableViewCell.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation
import UIKit
import SDWebImage

class RegionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RegionCell"
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = UIColor.Colors.labelPrimary
        return label
    }()
    
    private let likeButton: UIView = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let regionPicture = UIImageView()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        
        return stack
    }()
    

    
    func configure(with region: Brand) {
        regionLabel.text = region.title
        guard let imageUrl = URL(string: region.thumbUrls.first ?? "") else { return }
        regionPicture.sd_setImage(with: imageUrl)
        
        setupUI()
        regionPicture.layer.cornerRadius = 16
        regionPicture.clipsToBounds = true
        
    }
    
    func setupUI() {
//        verticalStack.backgroundColor = .blue
        contentView.backgroundColor = UIColor.Colors.backPrimary
        contentView.addSubview(verticalStack)
        verticalStack.addArrangedSubview(regionPicture)
        verticalStack.addArrangedSubview(regionLabel)
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        regionPicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            regionPicture.topAnchor.constraint(equalTo: verticalStack.topAnchor, constant: 16),
            regionPicture.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            regionPicture.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
            regionPicture.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regionLabel.leadingAnchor.constraint(equalTo: regionLabel.leadingAnchor),
            regionLabel.trailingAnchor.constraint(equalTo: regionLabel.trailingAnchor),
            regionLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
    
    
    
    
}
