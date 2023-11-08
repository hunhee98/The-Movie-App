//
//  DiscoverCollectionViewCell.swift
//  Media Project
//
//  Created by walkerhilla on 11/8/23.
//

import UIKit
import Kingfisher

final class DiscoverCollectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = "video-cell-reuse-identifier"
  
  private let imageView: UIImageView = {
    let view = UIImageView()
    view.contentMode = .scaleAspectFill
    return view
  }()
  
  private let titleLabel: UILabel = {
    let view = UILabel()
    view.numberOfLines = 1
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var movie: Movie?
  
  func configureView() {
    if let movie,
       let url = URL(string: movie.posterImageURL) {
      imageView.kf.setImage(with: url, options: [.transition(.fade(0.7))])
    }
  }
  
  private func setConstraints() {
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    
    imageView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview()
      make.height.greaterThanOrEqualToSuperview().multipliedBy(0.7)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(10)
      make.horizontalEdges.equalToSuperview().inset(15)
      make.bottom.equalToSuperview()
    }
  }
}
