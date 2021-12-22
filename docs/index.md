# Square In-App Payments iOS SDK SwiftUI

Build remarkable payments experiences in your SwiftUI app. This SDK is SwiftUI wrapper to the existing [In-App-Payments-SDK](https://raw.githubusercontent.com/square/in-app-payments-ios/) and is packed with everything you need to intergrate payments in your app.


# Information
While the project itself is stable it does rely on Squares In-App Payments SDK and updates to that SDK could break our implementaion so its on you to test your app fully before releasing to production.


# Installation/Setup

## Install Square InAppPaymentsSDK Frameworks
>YOU MUST INSTALL THE FRAMWORKS FOR THis PACKAGE TO WORK
1. Download and unzip the latest SquareInAppPaymentsSDK.zip artifact from the [Square In-App Payments Github repository release list](https://github.com/square/in-app-payments-ios/releases).
  
2.  Add the **SquareInAppPaymentsSDK** and **SquareBuyerVerificationSDK** frameworks to your project:
       1.  Open the **General** tab for your application target in Xcode.
       2.  Drag **SquareInAppPaymentsSDK.xcframework** and **SquareBuyerVerificationSDK.xcframework** from the unzipped folder into the **Embedded Binaries** section.
       3.  Choose **Copy Items if Needed**, and then choose **Finish** in the dialog box that appears.

## Install Square InAppPaymentsSDK SwiftUI
>Xcode 11 integrates with libSwiftPM to provide support for iOS platforms.

1. The preferred way of installing is via the [Swift Package Manager](https://swift.org/package-manager/).
	1. In Xcode, open your project and navigate to **File** → **Add Packages**
	2. Paste the repository URL (`https://github.com/realashleybailey/in-app-payments-ios-swiftui`) in the **Search or Enter Package URL** field
	3. For **Rules**, select **Branch** (with branch set to `main`).
	4. Click **Add Package**
	5. Click **Add Package** again when popup appears

# Documentaition
>Please visit [https://realashleybailey.github.io/in-app-payments-ios-swiftui/](https://realashleybailey.github.io/in-app-payments-ios-swiftui/) to read full documentation