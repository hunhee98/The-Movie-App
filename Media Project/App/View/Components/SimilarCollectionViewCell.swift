//
//  SimilarCollectionViewCell.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/21.
//

import UIKit
import Kingfisher

class SimilarCollectionViewCell: UICollectionViewCell {
  
  var movie: Movie?
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    posterImageView.contentMode = .scaleAspectFill
    
    titleLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .bold)
    titleLabel.textColor = .init(hexCode: Colors.text.stringValue)
  }
  
  func configureCell() {
    guard let movie else { return }
    
    if let url = URL(string: movie.posterImageURL) {
      posterImageView.kf.setImage(with: url)
    }
    
    titleLabel.text = movie.title
  }
  
}
