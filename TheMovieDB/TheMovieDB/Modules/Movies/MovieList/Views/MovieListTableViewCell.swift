//
//  MovieListTableViewCell.swift
//  TheMovieDB
//
//  Created by Karandeep Bhatia on 17/06/23.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var seeMoreButton: UIButton!
    // MARK: - Properties
    private var activityIndicator: UIActivityIndicatorView!
    var seeMoreTapped: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        addActivityIndicatorToPoster()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addActivityIndicatorToPoster() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = posterImageView.center
        activityIndicator.hidesWhenStopped = true
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func configureUI(from model: MovieListCellModel) {
        movieTitleLabel.text = model.movieTitle
        ratingLabel.text = "\(model.averageRating ?? 0.0)"
        releaseDateLabel.text = model.releaseDate
        overviewLabel.text = model.overview
    }
    
    func updateMoviePoster(image: UIImage?) {
        posterImageView.image = image
        stopActivityIndicator()
    }

    @IBAction func seeMoreButtonAction(_ sender: Any) {
        seeMoreTapped?()
    }
}
