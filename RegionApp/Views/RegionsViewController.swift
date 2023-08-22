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
    private var tableViewCell = RegionTableViewCell()
    
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
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.view = self
        tableViewCell.delegate = self
        
        
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
            let region = viewModel.region(at: indexPath.row)
            print("Configuring: \(region.title)")
            cell.delegate = self
            cell.configure(with: region, cellIndex: indexPath.row)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = viewModel.region(at: indexPath.row)


        navigationController?.pushViewController(DetailRegionsViewController(), animated: true)

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

extension RegionViewController: RegionTableViewCellDelegate {
    func didToggleLike(for indexPath: Int, isLiked: Bool) {
        viewModel.didTapLikeVC(isLiked: isLiked, at: indexPath)
        print("didToggleLike\(indexPath)")
        tableView.reloadData()
        
    }
    
    
}




