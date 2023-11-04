//
//  OnboardingButton.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/27.
//

import UIKit

class OnboardingButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureView(text: "Next")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureView(text: String) {
    var attStr = AttributedString(text.uppercased())
    attStr.font = .monospacedDigitSystemFont(ofSize: 14, weight: .bold)
    attStr.foregroundColor = .white
    var config = UIButton.Configuration.filled()
    config.attributedTitle = attStr
    config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    configuration = config
  }
  
}
