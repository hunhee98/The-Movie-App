//
//  DiscoverViewController.swift
//  Media Project
//
//  Created by walkerhilla on 11/8/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum DiscoverError: Error {
  case serverError
}

final class DiscoverViewController: UIViewController, UICollectionViewDelegate {
  
  let subTitle: UILabel = {
    let view = UILabel()
    view.text = Strings.Discover.subTitle.rawValue
    view.textColor = UIColor(hexCode: Colors.text.stringValue)
    view.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
    return view
  }()
  
  let mainTitle: UILabel = {
    let view = UILabel()
    view.text = Strings.Discover.mainTitle.rawValue
    view.textColor = UIColor(hexCode: Colors.primary.stringValue)
    view.font = .monospacedDigitSystemFont(ofSize: 27, weight: .bold)
    return view
  }()
  
  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    view.backgroundColor = UIColor(named: "backgroundSub")
    view.delegate = self
    return view
  }()
  
  var dataSource: UICollectionViewDiffableDataSource<Section, MovieItem>?
  let titleElementKind = "title-element-kind"
  
  let desiredGenres: [Genre] = [
      Genre(id: 53, name: "Thriller"),
      Genre(id: 10770, name: "TV Movie"),
      Genre(id: 878, name: "Science Fiction"),
      Genre(id: 10749, name: "Romance"),
      Genre(id: 9648, name: "Mystery"),
      Genre(id: 36, name: "History"),
      Genre(id: 14, name: "Fantasy"),
      Genre(id: 12, name: "Adventure"),
      Genre(id: 37, name: "Western"),
      Genre(id: 10752, name: "War")
  ]
  var movieList = PublishRelay<[MovieListGroupedByGenre]>()
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTitleLabel()
    setupCollectionView()
    configureDataSource()
    
    fetchMovies(desiredGenres)
    
    movieList.asDriver(onErrorJustReturn: [])
      .drive(with: self) { owner, value in
        owner.applySnapshot(value)
      }
      .disposed(by: disposeBag)
  }
  
  func fetchMovies(_ value: [Genre]) {
    let dispatchGroup = DispatchGroup()
    var list: [MovieListGroupedByGenre] = []
    value.forEach {
      dispatchGroup.enter()
      let genre = $0
      MovieAPIManager.shared.callRequest(type: .discover(genre.id), responseType: Trending.self) { result in
        if let movies = result?.results {
          list.append(MovieListGroupedByGenre(genre: genre, results: movies))
        }
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      self.movieList.accept(list)
    }
  }
  
  private func setupTitleLabel() {
    view.addSubview(subTitle)
    view.addSubview(mainTitle)
    
    subTitle.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.equalToSuperview().offset(20)
    }
    
    mainTitle.snp.makeConstraints { make in
      make.top.equalTo(subTitle.snp.bottom)
      make.leading.equalTo(subTitle)
      make.height.equalTo(subTitle).multipliedBy(1.7)
    }
  }
  
  private func setupCollectionView() {
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.top.equalTo(mainTitle.snp.bottom)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func applySnapshot(_ datas: [MovieListGroupedByGenre]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, MovieItem>()
    datas.forEach {
      if !$0.results.isEmpty {
      }
    }
    
    datas.forEach { data in
      if !data.results.isEmpty {
        snapshot.appendSections([.genre(data.genre)])
        data.results.forEach {
          snapshot.appendItems([MovieItem(genre: data.genre, movie: $0)], toSection: .genre(data.genre))
        }
      }
    }
    
    dataSource?.apply(snapshot)
  }
  
  private func createLayout() -> UICollectionViewLayout {
    let sectionProvider = { (sectionIndex: Int,
                             layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120),
                                           heightDimension: .absolute(190))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous
      section.interGroupSpacing = 12
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 0)
      
      let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .absolute(45))
      let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: titleSize,
        elementKind: self.titleElementKind,
        alignment: .top)
      section.boundarySupplementaryItems = [titleSupplementary]
      return section
    }
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 20
    
    let layout = UICollectionViewCompositionalLayout(
      sectionProvider: sectionProvider, configuration: config)
    return layout
  }
  
  private func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<DiscoverCollectionViewCell, MovieItem> { cell,indexPath,itemIdentifier in
      cell.movie = itemIdentifier.movie
      cell.configureView()
      cell.tapAction = { [weak self] movie in
        guard let self else { return }
        let vc = storyboard?.instantiateViewController(withIdentifier: MovieDetailViewController.identifier) as! MovieDetailViewController
        vc.movie = movie
        navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
      return cell
    })
    
    let supplementaryRegistration = UICollectionView.SupplementaryRegistration
    <TitleSupplementaryView>(elementKind: titleElementKind) { [weak self]
      (supplementaryView, string, indexPath) in
      
      guard let self else { return }
      
      guard let snapshot = dataSource?.snapshot() else { return }
      
      let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
      if case .genre(let genre) = videoCategory {
        supplementaryView.configureView(title: genre.name)
      }
    }
    
    dataSource?.supplementaryViewProvider = { (view, kind, index) in
      return self.collectionView.dequeueConfiguredReusableSupplementary(
        using: supplementaryRegistration, for: index)
    }
  }
}

extension DiscoverViewController {
  enum Section: Hashable {
    case genre(Genre)
  }
  
  struct MovieListGroupedByGenre {
    let genre: Genre
    let results: [Movie]
  }
  
  struct MovieItem: Hashable {
    let genre: Genre
    let movie: Movie
    
    static func == (lhs: MovieItem, rhs: MovieItem) -> Bool {
      lhs.genre.id == rhs.genre.id && lhs.movie.id == rhs.movie.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(genre.id)
      hasher.combine(movie.id)
    }
  }
}
