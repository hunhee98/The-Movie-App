//
//  MovieCollectionViewCell.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  
  var movie: Movie?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    posterImageView.backgroundColor = .init(hexCode: Colors.nonImage.stringValue)
    posterImageView.layer.cornerRadius = 8
    posterImageView.clipsToBounds = true
    posterImageView.contentMode = .scaleAspectFill
    
    titleLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
    titleLabel.textColor = .init(hexCode: Colors.text.stringValue)
    
    releaseDateLabel.font = .monospacedDigitSystemFont(ofSize: 11, weight: .bold)
    releaseDateLabel.textColor = .init(hexCode: Colors.primary.stringValue)
  }
  
  func configureCell() {
    guard let movie else { return }
    
    titleLabel.text = movie.title
    releaseDateLabel.text = movie.releaseDate
    
    if let url = URL(string: movie.posterImageURL) {
      posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.7))])
    }
  }
}
