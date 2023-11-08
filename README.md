# TheMovieApp | Toy Project

### 프로젝트 개요
- 인원: 1명
- 기간: 2023.08.12 - 2023.08.23

### 한 줄 소개
- 인기 영화 목록을 확인하고 가까운 영화관 정보를 얻는 iOS 앱 서비스

### 앱 미리보기

<p align="left" witdh="100%">
<img src="https://i.imgur.com/TjOM8ri.gif" width="24%">
<img src="https://i.imgur.com/PagnojW.gif" width="24%">
<img src="https://i.imgur.com/bFIs58r.gif" width="24%">
<img src="https://i.imgur.com/eOHl91i.gif" width="24%">
</p>

### 개발 환경
- Deployment Target: 15.0

### 이런 기술을 사용했어요
- Architecture: `MVC`
- iOS: `UIKit`
- UI: `Storyboard`, `SnapKit`
- Network: `Alamofire`, `SwiftyJSON`, `Codable`, `REST API`
- Image: `Kingfisher`
- Dependency Manager: `CocoaPods`, `SwiftPackageManager`

### 이런 기능들이 있어요
- 인기 영화 목록 제공
- 유사한 영화 목록 제공
- 영화 출연진, 제작진 및 줄거리 미리보기 제공
- 사용자 위치 기반 근처 영화관 목록 제공

### 트러블 슈팅
#### 1. 문자열 리터럴 리소스 관리
**문제 상황**:
UI와 컨텐츠에 사용되는 문자열이 리터럴 형태 그대로 코드와 결합되다보니 개발자가 코드 레벨에서 휴먼 에러를 발생할 가능성이 늘어나고 장기적으로 프로젝트 규모가 커지거나 다국어 대응 등의 상황을 고려했을 때 유지보수와 확장성이 매우 좋지 않은 형태였습니다.

**해결**: 문자열을 사용되는 기능, 화면 구조 단위로 열거형으로 분류하여 코드 레벨에서 발생할 수 있는 휴먼 에러를 최소화하고 리터럴이 재사용될 수 있는 형태로 만들었습니다. 추후 다국어를 추가해야하는 상황에도 용이하게 대응할 수 있습니다.

```Swift
enum Strings {
  enum Movies: String {
    case Movies
    case Trending
  }
  
  enum ComingSoon: String {
    case ComingSoon = "Coming Soon"
  }
  
  enum Details: String {
    case MovieDetails = "Movie Details"
  }
}
```

#### 2. 지도에서 카메라 이동 시점 이벤트를 구분할 수 없는 문제
**문제 상황**: 사용자가 지도의 카메라를 이동하였을 때 현재 지도에서 검색 버튼을 활성화하는 기능을 구현하던 도중, 지도가 화면에 처음 나타날 때 카메라를 설정하는 시점과 사용자가 카메라를 이동하는 시점의 이벤트가 동일한 메소드로 구현되어 있어 화면에 진입하자마자 현재 지도에서 검색 버튼이 활성화되는 문제가 발생했습니다.

**해결**: 네이버 지도 API의 공식 문서를 면밀히 리서치한 결과 해당 메소드의 파라미터로 카메라 이동의 원인에 대한 정보를 Int 값으로 넘겨주는 것을 확인하였습니다. 초기 카메라 설정 시에는 0, 사용자가 이동한 경우에는 -1를 반환되어 기능을 성공적으로 구현하였습니다.

```Swift
extension FinderViewController: NMFMapViewCameraDelegate {
  enum cameraDidChangeByReason: Int {
    case initial = 0
    case userInteraction = -1
  }
  
  func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    let reason = cameraDidChangeByReason(rawValue: reason)
    if case .userInteraction = reason {
      searchAgainButton.isHidden = false
    }
  }
}
```
