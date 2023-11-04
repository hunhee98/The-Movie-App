//
//  SimilarCollectionTableViewCell.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/22.
//

import UIKit

class SimilarCollectionTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var similarMovies: [Movie]?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    registerXib()
    registerDelegate()
    setupFlowLayout()
  }
  
  private func setupFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    let spacing: CGFloat = 10
    layout.itemSize = CGSize(width: 120, height: 200)
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    collectionView.collectionViewLayout = layout
  }
  
  private func registerXib() {
    let nib = UINib(nibName: SimilarCollectionViewCell.identifier, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier)
  }
  
  private func registerDelegate() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension SimilarCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let similarMovies else { return 0 }
    return similarMovies.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier, for: indexPath) as? SimilarCollectionViewCell,
          let similarMovies else { return UICollectionViewCell() }
    cell.movie = similarMovies[indexPath.item]
    cell.configureCell()
    return cell
  }
  
}
