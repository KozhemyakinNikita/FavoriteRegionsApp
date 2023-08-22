//
//  RegionsTableViewCell.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation
import UIKit
import SDWebImage

protocol RegionTableViewCellDelegate: AnyObject {
    func didToggleLike(for indexPath: IndexPath)
}

class RegionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RegionCell"
    weak var delegate: RegionTableViewCellDelegate?
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = UIColor.Colors.labelPrimary
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        button.setImage(UIImage(named: "likeButtonFilled"), for: .selected)
        button.tintColor = UIColor.Colors.colorRed
        button.translatesAutoresizingMaskIntoConstraints = false
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
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        print(likeButton.isSelected)
        print("TAPPED")
    }


    
    func setupUI() {
        contentView.backgroundColor = UIColor.Colors.backPrimary
        contentView.addSubview(verticalStack)
        regionPicture.addSubview(likeButton)
        regionPicture.isUserInteractionEnabled = true
        verticalStack.addArrangedSubview(regionPicture)
        verticalStack.addArrangedSubview(regionLabel)
        
        likeButton.tintColor = UIColor.Colors.colorRed
        
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
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: regionPicture.topAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: regionPicture.trailingAnchor, constant: -20),
            likeButton.heightAnchor.constraint(equalToConstant: 25),
            likeButton.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        
    }
    
    
    
    
}
