# TheMovieApp | Toy Project

### 프로젝트 개요
- 인원: 1명
- 기간: 2023.08.12 - 2023.08.16

### 한 줄 소개
- 인기, 장르 별 영화 목록을 제공하고 가까운 영화관 정보를 얻는 iOS 앱 서비스

### 앱 미리보기

<p align="left" witdh="100%">
<img src="https://i.imgur.com/TjOM8ri.gif" width="24%">
<img src="https://i.imgur.com/PagnojW.gif" width="24%">
<img src="https://i.imgur.com/bJe2oBE.gif" width="24%">
<img src="https://i.imgur.com/eOHl91i.gif" width="24%">
</p>

### 개발 환경
- Deployment Target: 15.0

### 이런 기술을 사용했어요
- Architecture: `MVC`
- iOS: `UIKit`
- UI: `Storyboard`, `SnapKit`
- Reactive: `RxSwift`
- Network: `Alamofire`, `SwiftyJSON`, `Codable`, `REST API`
- Image: `Kingfisher`
- Dependency Manager: `CocoaPods`, `SwiftPackageManager`

### 이런 기능들이 있어요
- 인기 영화 목록 제공
- 유사한 영화 목록 제공
- 장르 별 영화 목록 제공
- 영화 출연진, 제작진 및 줄거리 미리보기 제공
- 사용자 위치 기반 근처 영화관 목록 제공

### 주요 성과
* `Compositional Layout`를 사용하여 **UX 사용자 경험 개선**:   
장르 별 영화 컨텐츠 목록을 효과적으로 Present하고자 Horizontal Scroll View UI를 채택함. 이를 Compositional Layout으로 구현하여 스크롤이 중첩된 구조에서도 자연스러운 스크롤 애니메이션을 제공함
* `RxSwift` 리팩토링을 통한 코드 개선:   
기존 네트워크 통신 로직과 UI 업데이트 로직을 RxSwift 기반으로 수정하여 코드를 간결하고 에러처리에 용이한 구조를 이룸

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

### 회고
#### 새롭게 경험한 부분
* 네이버 지도 SDK를 사용하여 지도 화면을 구현하는 과정에서 지도의 동작 원리와 다양한 기능을 개발자의 관점에서 이해하게 되었습니다. 카메라 위치 설정, 어노테이션, 카메라 줌, 카메라 이동 애니메이션 등의 기능을 사용하며, 사용자로서 당연하게 여겼던 것들이 어떻게 동작하는지에 대한 깊은 이해를 얻게 되었습니다.
* 기존의 네트워크 통신 로직과 UI 업데이트 로직을 RxSwift로 수정하면서 **코드 리팩토링 프로세스**를 훈련하였습니다. 전체적인 구조를 파악한 뒤 Context, Method, Feature 단위로 점진적으로 수정하여 예기치 않은 에러 상황을 최소화하면서도 추적 가능한 형태로 리팩토링할 수 있었습니다.
#### 아쉬운 점
* 프로젝트의 UI를 Storyboard와 Codebase로 구성하면서 이 둘의 동작 원리와 차이에 대해 확실히 이해하는 계기가 되었습니다. 기능 구현과 학습에 중점을 둔 프로젝트이다보니 두 방식을 병행해서 사용하였지만, 어떠한 규칙이나 기준 없이 어떤 화면은 Storyboard를 사용하고 어떤 화면은 Codebase로 작성하면서 일관적이지 않은 구조를 이루었습니다. 다른 개발자와 협업하거나 지속적으로 프로젝트 규모가 커지는 상황이었다면 생산성을 저해하는 요소가 될 것이 분명하여 아쉬움이 남습니다.
* 코드를 작성하거나 구조를 설계하면서 "이게 정말 최선일까?" 라는 고민을 하느라 시간을 많이 허비하였는데 단순히 의문을 던지는 것만으로는 비효율적인 프로세스였던 것 같습니다. 제가 경험해본 바로는 고민하는 시간이 길어지는 것만큼 그 결과물이 질적으로 유의미한 발전을 이루지는 않았던 것 같습니다. 따라서 지저분한 코드여도 우선 기능을 구현한 후 작은 단위로 개선해 나아가는 것이 결과적으로 진전이 있는 프로세스라고 느끼게 되었습니다.
