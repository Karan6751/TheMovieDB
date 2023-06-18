//
//  SearchMovieViewController.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import UIKit
import Combine

final class SearchMovieViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var searchMovieLogoImageView: UIImageView!
    @IBOutlet private weak var searchMovieTextField: UITextField!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    // MARK: - Properties
    private let viewModel: SearchMovieViewModel
    private var anyCancellable: Set<AnyCancellable> = []
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animateSearchMovieLogo()
        addObserver()
        addActivityIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetSearchFieldText()
    }
    // MARK: - Constructor
    init?(viewModel: SearchMovieViewModel, code: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: code)
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
            .sink { [weak self] searchResult in
                self?.stopActivityIndicator()
                if searchResult != nil {
                    self?.navigateToMovieList(with: searchResult)
                } else {
                    self?.showErrorAlert()
                }
            }.store(in: &anyCancellable)
    }
    
    // MARK: - Search Action
    @IBAction func searchButtonAction(_ sender: Any) {
        guard let searchMovieText = searchMovieTextField.text, !searchMovieText.isEmpty else {
            shakeTextField()
            return
        }
        startActivityIndicator()
        viewModel.search(movie: searchMovieText)
    }
    
    private func navigateToMovieList(with searchResult: MovieSearchResponseModel?) {
        guard let searchResult else { return }
        let movieListVC = AppFactoryDIContainer.shared.makeMovieListViewController(movieList: searchResult)
        self.navigationController?.pushViewController(movieListVC, animated: true)
    }
    
    private func showErrorAlert() {
        guard let movieName = searchMovieTextField.text else {
            return
        }
        let alertController = UIAlertController(title: "Error Fetching Movie", message: "Unable To fetch \(movieName) please try later.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func resetSearchFieldText() {
        searchMovieTextField.text = ""
    }
    
    private func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = searchButton.center
        activityIndicator.hidesWhenStopped = true
    }
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    private func startActivityIndicator() {
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
}
// MARK: - logo Animation
extension SearchMovieViewController {
    private func shakeTextField() {
        UIView.animate(withDuration: 0.6, delay: 0.1) { [weak self] in
            self?.searchMovieTextField.layer.borderColor = UIColor.red.cgColor
            self?.searchMovieTextField.layer.borderWidth = 1
        }
        UIView.animate(withDuration: 0.6, delay: 0.1) { [weak self] in
            self?.searchMovieTextField.layer.borderColor = UIColor.clear.cgColor
            self?.searchMovieTextField.layer.borderWidth = 0
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10, 10, -10, 10, -5, 5, -2, 2, 0]
        searchMovieTextField.layer.add(animation, forKey: "shake")
    }
    
    private func animateSearchMovieLogo() {
        let originalCenterConstraint = centerConstraint.constant
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let self else { return }
            let centerX = self.view.bounds.width / 2.0
            let centerY = self.view.bounds.height / 2.0
            
            let radius: CGFloat = 100.0
            
            UIView.animate(withDuration: 2.0, delay: 0.0) {
                let angle = 2 * CGFloat.pi * (Date().timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 5.0))/5.0
                let newX = centerX + radius * cos(angle)
                let newY = centerY + radius * sin(angle)
                
                self.centerConstraint.constant = newX - newY
                self.view.layoutSubviews()
            } completion: { _ in
                self.centerConstraint.constant = originalCenterConstraint
                self.view.layoutSubviews()
            }
        })
    }
}
