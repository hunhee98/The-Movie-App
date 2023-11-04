//
//  MovieDetailViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/12.
//

import UIKit

final class MovieDetailViewController: UIViewController {
  
  //MARK: - IBOutlet Property
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var backImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var overViewTitleLabel: UILabel!
  @IBOutlet weak var divider: UIView!
  @IBOutlet weak var overViewLabel: UILabel!
  
  //MARK: - Stored Property
  
  var movie: Movie?
  lazy var credits: [[Cast]] = []
  lazy var similar: [Movie] = []
  lazy var sections: [SectionType] = [.cast, .crew, .similar]
  
  //MARK: - View Controller Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    dispatchGroup()
  }
  
  
  // MARK: - UI Setup
  
  func configureUI() {
    setupNavigationBar()
    setupTableView()
  }
  
  func setupNavigationBar() {
    navigationController?.navigationBar.topItem?.title = ""
    navigationController?.navigationBar.tintColor = UIColor(hexCode: Colors.primary.stringValue)
    
    let label = UILabel()
    label.text = Strings.Details.MovieDetails.rawValue
    label.textColor = UIColor(hexCode: Colors.primary.stringValue)
    label.font = .monospacedDigitSystemFont(ofSize: 19, weight: .bold)
    self.navigationItem.titleView = label
  }
  
  func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 100
    
    registerTableViewCell()
    setupTableHeaderView()
  }
  
  func registerTableViewCell() {
    let castCellNib = UINib(nibName: MovieContributorTableViewCell.identifier, bundle: nil)
    tableView.register(castCellNib, forCellReuseIdentifier: MovieContributorTableViewCell.identifier)
    let similarCellNib = UINib(nibName: SimilarCollectionTableViewCell.identifier, bundle: nil)
    tableView.register(similarCellNib, forCellReuseIdentifier: SimilarCollectionTableViewCell.identifier)
  }
  
  func setupTableHeaderView() {
    guard let movie else { return }

    backImageView.contentMode = .scaleAspectFill
    posterImageView.contentMode = .scaleAspectFill

    titleLabel.text = movie.title
    titleLabel.font = .monospacedDigitSystemFont(ofSize: 21, weight: .bold)
    titleLabel.textColor = UIColor(hexCode: Colors.text.stringValue)

    if let url = URL(string: movie.posterImageURL) {
      posterImageView.kf.setImage(with: url)
    }

    if let url = URL(string: movie.backdropImageURL) {
      backImageView.kf.setImage(with: url)
    }

    setupOverView()
  }
  
  func setupOverView(){
    overViewTitleLabel.text = "OverView"
    overViewTitleLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
    overViewTitleLabel.textColor = .systemGray
    
    divider.backgroundColor = UIColor(hexCode: Colors.divider.stringValue)
    
    guard let movie else { return }
    
    overViewLabel.text = movie.overview
    overViewLabel.numberOfLines = 0
    overViewLabel.textColor = UIColor(hexCode: Colors.text.stringValue)
  }
  
  //MARK: - API
  
  func callRequest() {
    guard let movie else { return }
    MovieAPIManager.shared.callRequest(type: .credits(movie.id), responseType: MovieContributor.self) { [weak self] data in
      guard let self,
            let data else { return }
      self.credits = [data.cast, data.crew]
    }
  }
  
  func callRequestSimilar() {
    guard let movie else { return }
    MovieAPIManager.shared.callRequest(type: .similar(movie.id), responseType: Similar.self) { [weak self] data in
      guard let self,
            let data else { return }
      self.similar = data.results
    }
  }
  
  func dispatchGroup() {
    let group = DispatchGroup()

    guard let movie else { return }
    
    group.enter()
    MovieAPIManager.shared.callRequest(type: .credits(movie.id), responseType: MovieContributor.self) { [weak self] data in
      guard let self,
            let data else { return }
      self.credits = [data.cast, data.crew]
      group.leave()
    }
    
    group.enter()
    MovieAPIManager.shared.callRequest(type: .similar(movie.id), responseType: Similar.self) { [weak self] data in
      guard let self,
            let data else { return }
      self.similar = data.results
      group.leave()
    }
    
    group.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
  
  //MARK: - Actions
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    indexPath.section != 2 ? 100 : 200
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard credits.count > 0 else { return 0 }
    switch section {
    case 0...1: return credits[section].count > 10 ? 10 : credits[section].count
    case 2: return 1
    default: return 0
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    sections[section].stringValue
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0...1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieContributorTableViewCell.identifier) as? MovieContributorTableViewCell else { return UITableViewCell() }
      let movieContributor = credits[indexPath.section][indexPath.row]
      cell.cast = movieContributor
      cell.configureCell()
      return cell
    case 2:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: SimilarCollectionTableViewCell.identifier) as? SimilarCollectionTableViewCell,
            similar.count > 0 else { return UITableViewCell() }
      cell.similarMovies = similar

      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(#function)
  }
}

extension MovieDetailViewController {
  enum SectionType: String {
    case cast = "Cast"
    case crew = "Crew"
    case similar = "Similar"
    
    var stringValue: String {
      self.rawValue
    }
  }
}
