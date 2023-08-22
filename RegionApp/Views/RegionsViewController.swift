//
//  RegionsViewController.swift
//  RegionApp
//
//  Created by Nik Kozhemyakin on 21.08.2023.
//

import Foundation
import UIKit

protocol RegionViewControllerLoaderDelegate {
    
}

class RegionViewController: UIViewController {
    private var viewModel = RegionViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.Colors.backPrimary
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if viewModel.isLoading {
            showLoader()
        } else {
            hideLoader()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регионы"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupActivityIndicator()
        viewModel = RegionViewModel()
        viewModel.fetchRegions()
        setupUI()
        viewModel.view = self
        
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.layer.zPosition = 1
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RegionTableViewCell.self, forCellReuseIdentifier: RegionTableViewCell.reuseIdentifier)
        //        tableView.backgroundColor = .white
        
    }
    
    func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = UIColor.Colors.backPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.numberOfRegions)
        return viewModel.numberOfRegions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RegionTableViewCell.reuseIdentifier, for: indexPath) as? RegionTableViewCell {
            var region = viewModel.region(at: indexPath.row)
            print("Configuring: \(region.title)")
            cell.configure(with: region)
//            cell.likeButton.isSelected = region.isLiked
            region.isLiked = cell.likeButton.isSelected
            viewModel.toggleLike(for: region)
            print("========START========")
            print(cell.likeButton.isSelected)
            print("================")
            print(region.isLiked)
            print("=======END=========")
//
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = viewModel.region(at: indexPath.row)

//        viewModel.toggleLike(for: region)
//        likeButton.isSelected = region.isLiked
        navigationController?.pushViewController(DetailRegionsViewController(), animated: true)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 332
    }
}

extension RegionViewController: RegionListViewReload {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
    }
}




