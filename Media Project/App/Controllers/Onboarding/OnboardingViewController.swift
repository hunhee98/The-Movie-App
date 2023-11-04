//
//  OnboardingViewController.swift
//  Media Project
//
//  Created by walkerhilla on 2023/08/27.
//

import UIKit
import SnapKit

class OnboardingViewController: UIPageViewController {
  
  let list: [UIViewController] = {
    return [
      IntroViewController(description: "인트로 1"),
      IntroViewController(description: "인트로 2"),
      IntroViewController(description: "인트로 3")
    ]
  }()
  
  @objc let nextButton: OnboardingButton = {
    let view = OnboardingButton()
    view.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    return view
  }()
  
  var currentPageIndex = 0
  
  override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    dataSource = self
    
    configureUI()
  }
  
  func configureUI() {
    view.backgroundColor = .black
    
    guard let intro = list.first else { return }
    setViewControllers([intro], direction: .forward, animated: true)
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(70)
      make.horizontalEdges.equalToSuperview().inset(20)
      make.height.equalTo(60)
    }
  }
  
  @objc func nextButtonTapped() {
    if currentPageIndex < list.count - 1 {
      currentPageIndex += 1
      setViewControllers([list[currentPageIndex]], direction: .forward, animated: true)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let viewController = storyboard.instantiateViewController(withIdentifier: "tabBarVC") as? UITabBarController else { return }
      UserDefaults.standard.setValue(true, forKey: "isLaunched")
      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
      let sceneDelegate = windowScene?.delegate as? SceneDelegate
      sceneDelegate?.window?.rootViewController = viewController
      sceneDelegate?.window?.makeKeyAndVisible()
    }
    setButtonLabel(index: currentPageIndex)
  }
  
  func setButtonLabel(index: Int) {
    if currentPageIndex == list.count - 1 {
      nextButton.configureView(text: "complete")
    } else {
      nextButton.configureView(text: "next")
    }
  }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
    let previousIndex = currentIndex - 1
    return previousIndex < 0 ? nil : list[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let currentIndex = list.firstIndex(of: viewController) else { return nil }
    let afterIndex = currentIndex + 1
    return afterIndex >= list.count ? nil : list[afterIndex]
  }
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return list.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    guard let first = viewControllers?.first, let index = list.firstIndex(of: first) else { return 0 }
    return index
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let currentVC = pageViewController.viewControllers?.first {
        for (index, vc) in list.enumerated() {
          if vc == currentVC {
            currentPageIndex = index
            setButtonLabel(index: currentPageIndex)
          }
        }
      }
    }
  }
}
