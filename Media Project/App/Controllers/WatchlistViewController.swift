//
//  WatchlistViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import UIKit

final class WatchlistViewController: UIViewController {
  
  //MARK: - IBOutlet Property
  
  @IBOutlet weak var subTitle: UILabel!
  @IBOutlet weak var mainTitle: UILabel!
  @IBOutlet weak var watchlistCollectionView: UICollectionView!
  
  //MARK: - Stored Property
  
  lazy var movieData: [Movie] = []
  
  //MARK: - View Controller Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    callRequest()
  }
  
  //MARK: - UI setup
  
  func configureUI() {
    
    titleLabel()
    setupTabBar()
    setupCollectionView()
  }
  
  func titleLabel() {
    subTitle.text = Strings.Movies.Movies.rawValue
    subTitle.textColor = UIColor(hexCode: Colors.text.stringValue)
    mainTitle.text = Strings.Movies.Trending.rawValue
    mainTitle.textColor = UIColor(hexCode: Colors.primary.stringValue)
    mainTitle.font = .monospacedDigitSystemFont(ofSize: 27, weight: .bold)
  }
  
  func setupTabBar() {
    tabBarController?.tabBar.tintColor = UIColor(hexCode: Colors.primary.stringValue)
  }

  func setupCollectionView() {
    watchlistCollectionView.dataSource = self
    watchlistCollectionView.delegate = self
    
    let nib = UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil)
    watchlistCollectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    
    let layout = UICollectionViewFlowLayout()
    let spacing: CGFloat = 20
    let width = UIScreen.main.bounds.width - spacing * 3
    layout.itemSize = CGSize(width: width/2, height: width/2 * 1.6)
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 3, left: spacing, bottom: spacing, right: spacing)
    
    watchlistCollectionView.collectionViewLayout = layout
  }
  
  //MARK: - API
  
  func callRequest() {
    MovieAPIManager.shared.callRequest(type: .trending(.week), responseType: Trending.self) { [weak self] data in
      guard let self,
            let data else { return }
      self.movieData = data.results
      self.watchlistCollectionView.reloadData()
    }
  }
}

//MARK: - Extenstion

extension WatchlistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    movieData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let movie = movieData[indexPath.row]
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier , for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
    cell.movie = movie
    cell.configureCell()
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let movie = movieData[indexPath.row]
    print(MovieDetailViewController.identifier)
    let vc = storyboard?.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
    vc.movie = movie
    
    navigationController?.pushViewController(vc, animated: true)
  }
}
