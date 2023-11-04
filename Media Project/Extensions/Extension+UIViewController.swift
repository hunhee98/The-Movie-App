//
//  Extension+UIViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import UIKit

extension UIViewController: Reusable {
  static var identifier: String {
    String(describing: self)
  }
}
