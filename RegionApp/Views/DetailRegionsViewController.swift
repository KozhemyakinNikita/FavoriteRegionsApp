//
//  DetailRegionsViewController.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 22.08.2023.
//

import Foundation
import UIKit

// MARK: - class DetailRegionsViewController: UIViewController

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
        label.textAlignment = .left
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
        control.currentPageIndicatorTintColor = .Colors.labelPrimary
        control.pageIndicatorTintColor = .gray
        control.addTarget(self, action: #selector(pageControlTapped), for: .valueChanged)
        
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
        button.setTitleColor(.Colors.labelPrimary, for: .normal)
        button.addTarget(self, action: #selector(toggleNextButton), for: .touchUpInside)
        return button
    }()
    
    private let eyeIcon: UIImageView = {
        let eye = UIImageView(image: UIImage(named: "eyeIcon"))
        eye.tintColor = UIColor.Colors.labelPrimary
        return eye
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor.Colors.labelPrimary
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setupUI()
        configureUI()
        carouselCollectionView.detailViewModel = viewModel
        
        setupColors()
        setupNavigationBar()
        setupBottomControls()
        carouselCollectionView.delegateSwipe = self
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        eyeIcon.contentMode = .right
        view.addSubview(carouselCollectionView)
        view.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(likeButton)
        horizontalStack.addArrangedSubview(eyeIcon)
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
        
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewsLabel.widthAnchor.constraint(equalToConstant: 50),
            viewsLabel.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
        ])
        
        
        
    }
    
    private func setupColors() {
        view.backgroundColor = .Colors.backPrimary
        carouselCollectionView.backgroundColor = .Colors.backPrimary
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "chevronLeft"),
            style: .done,
            target: self,
            action: #selector(backButtonPrevious)
        )
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .Colors.labelPrimary
    }
    
    
    private func configureUI() {
        guard let viewModel else { return }
        
        titleLabel.text = viewModel.title
        regionImageView.sd_setImage(with: viewModel.imageUrls.first)
        viewsLabel.text = String(viewModel.viewsCount)
        
        if viewModel.isLiked {
            likeButton.setImage(UIImage(named: "likeButtonFilled"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "likeButton"), for: .normal)
        }
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
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
    
    private func updatePreviousButtonAvailability() {
        previousButton.isEnabled = pageControl.currentPage > 0
        previousButton.setTitleColor(previousButton.isEnabled ? .Colors.labelPrimary : .gray, for: .normal)
    }
    
    private func updateNextButtonAvailability() {
        let maxIndex = (viewModel?.imageUrls.count ?? 1) - 1
        nextButton.isEnabled = pageControl.currentPage < maxIndex
        nextButton.setTitleColor(nextButton.isEnabled ? .Colors.labelPrimary : .gray, for: .normal)
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
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func backButtonPrevious() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func likeButtonTapped() {
        guard let viewModel else { return }
        
        viewModel.isLiked.toggle()
        animateLikeButton()
        viewModel.toggleLike(isLiked: viewModel.isLiked)
        configureUI()
    }
    
    @objc private func togglePreviousButton() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updatePreviousButtonAvailability()
        updateNextButtonAvailability()
        
    }
    
    @objc private func toggleNextButton() {
        let nextIndex = min(pageControl.currentPage + 1, (viewModel?.imageUrls.count ?? 1) - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updatePreviousButtonAvailability()
        updateNextButtonAvailability()
    }
    
    @objc private func pageControlTapped() {
        let selectedPage = pageControl.currentPage
        let indexPath = IndexPath(item: selectedPage, section: 0)
        carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updatePreviousButtonAvailability()
        updateNextButtonAvailability()
    }
    
    
}

// MARK: - Extentions

extension DetailRegionsViewController: CarouselCollectionViewDelegate {
    func collectionView(_ collectionView: CarouselCollectionView, didChangePageTo index: Int) {
        pageControl.currentPage = index
        updatePreviousButtonAvailability()
        updateNextButtonAvailability()
    }
}
