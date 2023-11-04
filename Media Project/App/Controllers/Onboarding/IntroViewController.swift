//
//  IntroViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/27.
//

import UIKit

class IntroViewController: UIViewController {
  
  let label: UILabel = {
    let view = UILabel()
    view.textColor = .white
    view.font = .systemFont(ofSize: 16, weight: .bold)
    view.textAlignment = .center
    return view
  }()
  
  init(description: String) {
    super.init(nibName: nil, bundle: nil)
    self.label.text = description
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(label)
    label.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  
}
