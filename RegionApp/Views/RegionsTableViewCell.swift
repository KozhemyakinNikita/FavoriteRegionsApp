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
    func didToggleLike(for indexPath: Int, isLiked: Bool)
}

class RegionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RegionCell"
    weak var delegate: RegionTableViewCellDelegate?
    var isLiked = false
    var index = 0
    
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
        button.tintColor = UIColor.Colors.colorRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //    private let regionPicture = UIImageView()
    private let regionPicture: UIImageView = {
        let picture = UIImageView()
        picture.layer.cornerRadius = 16
        picture.clipsToBounds = true
        return picture
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        
        return stack
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isLiked = false
        likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
        delegate = nil
    }
    
    
    func configure(with region: Brand, cellIndex: Int) {
        isLiked = region.isLiked
        index = cellIndex
        regionLabel.text = region.title
        guard let imageUrl = URL(string: region.thumbUrls.first ?? "") else { return }
        regionPicture.sd_setImage(with: imageUrl)
        
        setupUI()
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.tintColor = region.isLiked ? UIColor.Colors.colorRed : UIColor.Colors.colorRed
        
        if isLiked {
            likeButton.setImage(UIImage(named: "likeButtonFilled"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
        }
        
    }
    
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        delegate?.didToggleLike(for: index, isLiked: isLiked)
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
