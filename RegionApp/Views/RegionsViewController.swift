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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            RegionTableViewCell.self,
            forCellReuseIdentifier: RegionTableViewCell.reuseIdentifier
        )
        tableView.backgroundColor = UIColor.Colors.backPrimary
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        viewModel.isLoading ? showLoader() : hideLoader()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    
    private func setup() {
        setupNavBar()
        setupTableView()
        setupUI()
        
        viewModel.fetchRegions()
        viewModel.loadingDelegate = self
    }
    
    private func setupNavBar() {
        title = "Регионы"
        navigationController?.navigationBar.prefersLargeTitles = true
        //        navigationController?.navigationBar.backgroundColor = UIColor.Colors.navigationColor
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.backgroundColor = UIColor.Colors.navigationColor
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.numberOfRegions)
        return viewModel.numberOfRegions
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RegionTableViewCell.reuseIdentifier,
            for: indexPath) as? RegionTableViewCell else {
            return UITableViewCell()
        }
        
        let region = viewModel.region(at: indexPath.row)
        print("Configuring: \(region.title)")
        cell.delegate = self
        cell.configure(with: region, cellIndex: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let region = viewModel.region(at: indexPath.row)
        let detailViewModel = DetailRegionsViewModel(region: region, index: indexPath.row)
        let detailViewController = DetailRegionsViewController()
        detailViewController.viewModel = detailViewModel
        detailViewModel.delegate = self
            
        navigationController?.pushViewController(detailViewController, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? RegionTableViewCell {
                // Apply the animation
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        cell.transform = .identity
                    }
                })
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325   //332
    }
}

extension RegionViewController: RegionListViewReload {
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK: - Change

extension RegionViewController: RegionTableViewCellDelegate {
    func didToggleLike(for indexPath: Int, isLiked: Bool) {
        viewModel.didTapLikeVC(isLiked: isLiked, at: indexPath)
        print("didToggleLike\(indexPath)")
        tableView.reloadData() //change to reload current row
        
    }
}
