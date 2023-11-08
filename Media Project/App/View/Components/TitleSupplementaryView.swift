//
//  TitleSupplementaryView.swift
//  Media Project
//
//  Created by walkerhilla on 11/8/23.
//

import UIKit
import SnapKit

final class TitleSupplementaryView: UICollectionReusableView {
  private let label: UILabel = {
    let view = UILabel()
    view.font = .monospacedDigitSystemFont(ofSize: 19, weight: .bold)
    return view
  }()
  
  static let reuseIdentifier = "title-supplementary-reuse-identifier"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    label.text = nil
  }
  
  func configureView(title: String) {
    label.text = title
  }
  
  private func setConstraints() {
    addSubview(label)
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
