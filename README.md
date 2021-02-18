![Screenshot](fr2.png)
# FaceAI

This package is aim to make using Computer Vision simple as possible.
FaceAI use 2 main features.
1. Creating a Vision Operations Pipe.
2. Creating a Stack Operation over desired photos.

# Requirement
- iOS 13.0+
- Swift 5.1+
- Xcode 12.0+

# Install
SPM:
```
dependencies: [
  .package(
      url:  "https://github.com/LA-Labs/FaceAI.git",
      .branch("master")
  )
]
```
# Usage
## Import
Import FaceAI module to your calss
```swift 
import FaceAI
```
## Basic Usage
Face detection over the photo library
```swift 
let options = AssetFetchingOptions()
let faceRectangle = VFilter.faceRectangle()
FaceAI.detect(faceRectangle, with: options) { (result) in
   switch result {
   // The result type is ProcessedAsset
   // Containt all photos with face recatangle detection
   // photos[0].boundingBoxes
      case .success(let photos):
          print(photos)
      case .failure(let error):
          print(error)
   }
}
```
