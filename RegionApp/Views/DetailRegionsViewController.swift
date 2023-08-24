//
//  DetailRegionsViewController.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 22.08.2023.
//

import Foundation
import UIKit

class DetailRegionsViewController: UIViewController {
    var viewModel: DetailRegionsViewModel?
    
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
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 8
        
        return stack
    }()
    
    private var carouselCollectionView = CarouselCollectionView()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = viewModel?.imageUrls.count ?? 1
        control.currentPageIndicatorTintColor = .green
        control.pageIndicatorTintColor = .blue
        return control
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Назад", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(togglePreviousButton), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вперед", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(toggleNextButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.Colors.labelPrimary
        setupUI()
        configureUI()
        carouselCollectionView.detailViewModel = viewModel
        
        setupColors()
        setupBottomControls()
        carouselCollectionView.delegateSwipe = self
    }
    
    private func setupColors() {
        view.backgroundColor = .Colors.backPrimary
        carouselCollectionView.backgroundColor = .Colors.backPrimary
        //        view.backgroundColor = .blue
        //        verticalStack.backgroundColor = .green
        //        horizontalStack.backgroundColor = .gray
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        // view.addSubview(regionImageView)
        view.addSubview(carouselCollectionView)
        view.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(likeButton)
        horizontalStack.addArrangedSubview(viewsLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            carouselCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            carouselCollectionView.heightAnchor.constraint(equalToConstant: 326)
        ])
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            horizontalStack.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 8),
        ])
        
    }
    
    
    private func configureUI() {
        guard let viewModel else { return }
        
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
        guard let viewModel else { return }
        
        viewModel.isLiked.toggle()
        animateLikeButton()
        viewModel.toggleLike(isLiked: viewModel.isLiked)
        configureUI()
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
    
    @objc private func togglePreviousButton() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @objc private func toggleNextButton() {
        let nextIndex = min(pageControl.currentPage + 1, (viewModel?.imageUrls.count ?? 1) - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    private func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
}


extension DetailRegionsViewController: CarouselCollectionViewDelegate {
    func collectionView(_ collectionView: CarouselCollectionView, didChangePageTo index: Int) {
        pageControl.currentPage = index
    }
}
