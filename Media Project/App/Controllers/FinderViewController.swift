//
//  FinderViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/23.
//

import UIKit
import CoreLocation
import SnapKit
import NMapsMap

class FinderViewController: UIViewController {
  // MARK: - Properties
  let locationManager = CLLocationManager()
  let mapView = NMFMapView(frame: .zero)
  var mapMarkers: [NMFMarker] = []

  // MARK: - UI Elements
  lazy var currentLocationButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
    let image = UIImage(systemName: "location.fill", withConfiguration: config)
    button.setImage(image, for: .normal)
    button.backgroundColor = .black
    button.layer.cornerRadius = 20
    button.tintColor = UIColor(hexCode: Colors.primary.stringValue)
    button.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
    return button
  }()
  
  lazy var searchAgainButton: UIButton = {
    let button = UIButton()
    button.setTitle("현 위치에서 검색", for: .normal)
    button.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
    button.backgroundColor = .black
    button.layer.cornerRadius = 20
    button.setTitleColor(UIColor(hexCode: Colors.primary.stringValue), for: .normal)
    button.isHidden = true
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupLocationManager()
    configureUI()
    checkDeviceLocationAuthorization()
    updateCameraToUserLocation()
  }
  
  // MARK: - Location Setup
  func setupLocationManager() {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  // MARK: - UI Configuration
  func configureUI() {
    tabBarController?.tabBar.backgroundColor = .black
    setupMapView()
    setupCurrentLocationButton()
    setupSearchAgainButton()
  }
  
  func setupMapView() {
    view.addSubview(mapView)
    mapView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    mapView.positionMode = .direction
    mapView.addCameraDelegate(delegate: self)
    mapView.zoomLevel = 12
  }
  
  func setupCurrentLocationButton() {
    view.addSubview(currentLocationButton)
    currentLocationButton.snp.makeConstraints { make in
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-13)
      make.size.equalTo(40)
    }
  }
  
  func setupSearchAgainButton() {
    view.addSubview(searchAgainButton)
    searchAgainButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
      make.centerX.equalToSuperview()
      make.height.equalTo(40)
      make.width.equalTo(130)
    }
  }
  
  // MARK: - Location Authorization
  func checkDeviceLocationAuthorization() {
    DispatchQueue.global().async { [weak self] in
      guard let self else { return }
      if CLLocationManager.locationServicesEnabled() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
          authorizationStatus = self.locationManager.authorizationStatus
        } else {
          authorizationStatus = CLLocationManager.authorizationStatus()
        }
        self.handleLocationAuthorizationStatus(status: authorizationStatus)
      }
    }
  }
  
  func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
    case .denied, .restricted:
      //      let defaultLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
      //      setRegionAndAddMarkers(center: defaultLocation)
      DispatchQueue.main.async {
        self.presentLocationServiceAlert()
      }
    case .authorizedWhenInUse, .authorizedAlways, .authorized:
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
    @unknown default: break
    }
  }
  
  // MARK: - Marker Management
  func addMapMarker(coordinate: CLLocationCoordinate2D, title: String) {
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
    marker.captionText = title
    marker.mapView = mapView
    mapMarkers.append(marker)
  }
  
  // MARK: - User Alerts
  func presentLocationServiceAlert() {
    let alert = UIAlertController(title: "Location Service", message: "Location service is not available. Please enable it in your device's settings.", preferredStyle: .alert)
    let openSettingsAction = UIAlertAction(title: "Open Settings", style: .destructive) { _ in
      if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
        UIApplication.shared.open(settingsURL)
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    alert.addAction(cancelAction)
    alert.addAction(openSettingsAction)
    present(alert, animated: true)
  }
  
  // MARK: - Current Location Button Tapped
  @objc func currentLocationButtonTapped() {
    updateCameraToUserLocation()
  }
  
  // MARK: - Search Again Button Tapped
  @objc func searchButtonTapped() {
    let cameraPosition = mapView.cameraPosition
    let centerCoordinate = cameraPosition.target
    
    fetchNearbyTheaters(CLLocationCoordinate2D(latitude: centerCoordinate.lat, longitude: centerCoordinate.lng))
    searchAgainButton.isHidden = true
  }
  
  // MARK: - Camera Updates
  func updateCameraToUserLocation() {
    if let userLocation = locationManager.location?.coordinate {
      let currentLocation = NMGLatLng(lat: userLocation.latitude, lng: userLocation.longitude)
      let cameraUpdate = NMFCameraUpdate(scrollTo: currentLocation)
      mapView.moveCamera(cameraUpdate)
      fetchNearbyTheaters(userLocation)
    }
  }
  
  // MARK: - API Request
  func fetchNearbyTheaters(_ location: CLLocationCoordinate2D) {
    NaverPlaceAPIManager.shared.callRequest(type: .search((location.latitude, location.longitude)), responseType: Place.self) { [weak self] result in
      guard let self else { return }
      result?.place.forEach { place in
        let title = place.title
        if let latitude = Double(place.y), let longitude = Double(place.x) {
          let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
          self.addMapMarker(coordinate: coordinate, title: title)
        }
      }
    }
  }
}

extension FinderViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(#function)
    print(locations)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(#function)
    print(error)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkDeviceLocationAuthorization()
    print(#function)
  }
}

extension FinderViewController: NMFMapViewCameraDelegate {
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    if reason == -1 {
      searchAgainButton.isHidden = false
    }
  }
}
