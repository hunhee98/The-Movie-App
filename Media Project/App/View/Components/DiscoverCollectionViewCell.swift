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
    view.contentMode = .scaleToFill
    return view
  }()
  
  private let titleLabel: UILabel = {
    let view = UILabel()
    view.font = .monospacedDigitSystemFont(ofSize: 12, weight: .bold)
    view.textAlignment = .center
    view.numberOfLines = 1
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setConstraints()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
    contentView.addGestureRecognizer(tapGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var movie: Movie?
  var tapAction: ((Movie) -> ())?
  
  @objc func cellTapped() {
    guard let movie else { return }
    tapAction?(movie)
  }
  
  func configureView() {
    if let movie,
       let url = URL(string: movie.posterImageURL) {
      imageView.kf.setImage(with: url, options: [.transition(.fade(0.7))])
    }
    titleLabel.text = movie?.title
  }
  
  private func setConstraints() {
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    
    imageView.snp.makeConstraints { make in
      make.top.horizontalEdges.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.85)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(5)
      make.centerX.equalToSuperview()
      make.leading.trailing.greaterThanOrEqualToSuperview().inset(5)
      make.bottom.equalToSuperview().offset(-5)
    }
  }
}
