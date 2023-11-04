//
//  MovieContributorTableViewCell.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import UIKit

final class MovieContributorTableViewCell: UITableViewCell {
  
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nonProfileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var divider: UIView!
  
  var cast: Cast?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    selectionStyle = .none
    
    profileImageView.layer.cornerRadius = 8
    profileImageView.clipsToBounds = true
    profileImageView.backgroundColor = .init(hexCode: Colors.nonImage.stringValue)
    profileImageView.contentMode = .scaleAspectFill
    
    nameLabel.textColor = .init(UIColor(hexCode: Colors.text.stringValue))
    nameLabel.font = .monospacedDigitSystemFont(ofSize: 17, weight: .semibold)
    
    infoLabel.textColor = .init(UIColor(hexCode: Colors.subtext.stringValue))
    infoLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
    
    divider.backgroundColor = .init(UIColor(hexCode: Colors.divider.stringValue))
  }
  
  func configureCell() {
    guard let cast else { return }
    
    if let url = cast.profileImageURL,
       let url = URL(string: url) {
      profileImageView.kf.setImage(with: url)
    } else {
      nonProfileImage.image = UIImage(systemName: "person.fill")
      nonProfileImage.tintColor = .gray
      profileImageView.backgroundColor = .clear
    }
    
    nameLabel.text = cast.name
    
    switch cast.role {
    case .cast:
      infoLabel.text = "\(cast.character ?? "")"
    case .crew:
      infoLabel.text = "\(cast.job ?? "")"
    }
  }
  
}
