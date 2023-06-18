//
//  MovieListViewController.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import UIKit
import Combine

final class MovieListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet private weak var movieListTableView: UITableView!
    // MARK: - Properties
    private let viewModel: MovieListViewModel
    private var anyCancellable: Set<AnyCancellable> = []
    // MARK: - View Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    // MARK: - Constructor
    init?(viewModel: MovieListViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        anyCancellable.removeAll()
    }
    
    // MARK: - Observer
    private func addObserver() {
        viewModel.updateUI
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cellModels in
                self?.reloadTable()
            }.store(in: &anyCancellable)
        viewModel.updateUIOnImageDownload
            .receive(on: DispatchQueue.main)
            .sink { [weak self] indexPath in
                self?.movieListTableView.reloadRows(at: [indexPath], with: .none)
            }.store(in: &anyCancellable)
    }
    // MARK: - TableView related methods
    private func reloadTable() {
        movieListTableView.reloadData()
    }
    
    private func setupTableView() {
        movieListTableView.delegate = self
        movieListTableView.dataSource = self
    }
}
// MARK: - TableView Delage & Data Source
extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MovieListTableViewCell.self)", for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
        }
        if viewModel.expandedRows.contains(indexPath.row) {
            cell.overviewLabel.numberOfLines = 0
            cell.overviewLabel.lineBreakMode = .byWordWrapping
            cell.seeMoreButton.setTitle("See less", for: .normal)
        } else {
            cell.overviewLabel.numberOfLines = 2
            cell.overviewLabel.lineBreakMode = .byTruncatingTail
        }
        cell.seeMoreTapped = { [weak self] in
            self?.handleSeeMoreLessAction(indexPath: indexPath, tableView: tableView)
        }
        cell.selectionStyle = .none
        if indexPath.row <= viewModel.cellModels.count {
            cell.configureUI(from: viewModel.getCellModel(at: indexPath))
        }
        if indexPath.row < viewModel.photos.count {
            let photoDetails = viewModel.getPhotoRecord(at: indexPath)
            switch photoDetails.state {
            case .new:
                viewModel.startOperation(for: photoDetails, at: indexPath)
            case .downloaded, .failed:
                cell.updateMoviePoster(image: photoDetails.image)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleSeeMoreLessAction(indexPath: indexPath, tableView: tableView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.suspendAllOperations()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate, let indexPathForVisibleRows = movieListTableView.indexPathsForVisibleRows {
            viewModel.loadImageForVisibleRows(visibleRows: indexPathForVisibleRows)
            viewModel.resumeAllOperations()
        }
    }
    
    private func handleSeeMoreLessAction(indexPath: IndexPath, tableView: UITableView) {
        if viewModel.expandedRows.contains(indexPath.row) == true {
            viewModel.expandedRows.remove(indexPath.row)
        } else {
            viewModel.expandedRows.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
