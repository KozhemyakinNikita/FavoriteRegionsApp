//
//  RegionsTableViewCell.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation
import UIKit
import SDWebImage

// MARK: - Protocols

protocol RegionTableViewCellDelegate: AnyObject {
    func didToggleLike(for index: Int, isLiked: Bool)
    func didToggleLikeFromDetailVC(for index: Int, isLiked: Bool)
}

// MARK: - class RegionTableViewCell: UITableViewCell

class RegionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "RegionCell"
    weak var delegate: RegionTableViewCellDelegate?
    var isLiked = false {
        didSet {
            let imageName = self.isLiked ? "likeButtonFilled" : "likeButton"
            self.likeButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    var index = 0
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = UIColor.Colors.labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0.97
        blurEffectView.layer.cornerRadius = 16
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        button.tintColor = UIColor.Colors.colorRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let regionPicture: UIImageView = {
        let picture = UIImageView()
        picture.clipsToBounds = true
        picture.layer.cornerRadius = 16
        picture.translatesAutoresizingMaskIntoConstraints = false
        return picture
    }()
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 16
        containerView.dropShadow(color: UIColor.systemGray, opacity: 1, offSet: CGSize(width: .zero, height: 0), radius: 7)
    }
    
    
    func configure(with region: Brand, cellIndex: Int) {
        isLiked = region.isLiked
        index = cellIndex
        regionLabel.text = region.title
        guard let imageUrl = URL(string: region.thumbUrls.first ?? "") else { return }
        regionPicture.sd_setImage(with: imageUrl)
        
        setupUI()
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        setupConstraints()
        regionPicture.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        
        contentView.backgroundColor = UIColor.Colors.backPrimary
        
        //        contentView.addSubview(regionPicture)
        contentView.insertSubview(containerView, belowSubview: regionPicture)
        containerView.addSubview(regionPicture)
        regionPicture.addSubview(likeButton)
        
        contentView.addSubview(blurView)
        contentView.addSubview(regionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerView.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        NSLayoutConstraint.activate([
            regionPicture.topAnchor.constraint(equalTo: containerView.topAnchor),
            regionPicture.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            regionPicture.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            regionPicture.heightAnchor.constraint(equalToConstant: 275)
        ])
        
        NSLayoutConstraint.activate([
            regionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            regionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            regionLabel.bottomAnchor.constraint(equalTo: regionPicture.bottomAnchor, constant: 20),
            regionLabel.centerXAnchor.constraint(equalTo: regionPicture.centerXAnchor),
            regionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            blurView.bottomAnchor.constraint(equalTo: regionPicture.bottomAnchor, constant: 20),
            blurView.centerXAnchor.constraint(equalTo: regionPicture.centerXAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: regionPicture.topAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: regionPicture.trailingAnchor, constant: -20),
            likeButton.heightAnchor.constraint(equalToConstant: 25),
            likeButton.widthAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    private func animateLikeButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.likeButton.transform = self.likeButton.transform.scaledBy(x: 0.8, y: 0.8)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.likeButton.transform = CGAffineTransform.identity
            })
        })
    }
    
    private func colors() {
        contentView.backgroundColor = .red
        regionLabel.backgroundColor = .green
        regionPicture.backgroundColor = .yellow
    }
    
    @objc private func likeButtonTapped() {
        isLiked.toggle()
        animateLikeButton()
        if isLiked {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        delegate?.didToggleLike(for: index, isLiked: isLiked)
    }
}
