//
//  DetailRegionsViewController.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 22.08.2023.
//

import Foundation
import UIKit

class DetailRegionsViewController: UIViewController {
    var viewModel: DetailRegionsViewModel!
    
    
    var liked = false
    private let regionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textAlignment = .right
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        button.tintColor = UIColor.Colors.colorRed
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        
        return stack
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        return stack
    }()
    
    private var carouselCollectionView = CarouselCollectionView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.Colors.labelPrimary
        setupUI()
        configureUI()
        carouselCollectionView.detailViewModel = viewModel
    }
    
    private func setupUI() {
        view.backgroundColor = .blue
        verticalStack.backgroundColor = .green
        view.addSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
//        verticalStack.addArrangedSubview(regionImageView)
        verticalStack.addArrangedSubview(carouselCollectionView)
        verticalStack.addArrangedSubview(horizontalStack)
        horizontalStack.addArrangedSubview(likeButton)
        horizontalStack.addArrangedSubview(viewsLabel)
      
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            //            verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 16),
//            titleLabel.topAnchor.constraint(equalTo: verticalStack.topAnchor, constant: 1),
//            titleLabel.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -16),
        ])

//        regionImageView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
////            regionImageView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 8),
////            regionImageView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -8),
//            regionImageView.widthAnchor.constraint(equalToConstant: 343),
//            regionImageView.heightAnchor.constraint(equalToConstant: 326)
//
//        ])
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            regionImageView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: 8),
//            regionImageView.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -8),
            carouselCollectionView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 326)
            
        ])
        

        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),

        ])
        horizontalStack.backgroundColor = .gray
        
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            likeButton.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.45)
//        ])
//
//        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            viewsLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.6)
//        ])
        
        
        
        
    }
    
    private func configureUI() {
        titleLabel.text = viewModel.title
        regionImageView.sd_setImage(with: viewModel.imageUrls.first)
        viewsLabel.text = "Просмотров: \(viewModel.viewsCount)"
        
        if viewModel.isLiked {
            likeButton.setImage(UIImage(named: "likeButtonFilled"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped() {
//        liked.toggle()
        viewModel.isLiked.toggle()
        viewModel.toggleLike(isLiked: viewModel.isLiked)
        configureUI()
    }
}

