About
----
Complete project responsible for tracking user, archiving his locations and sending them to the cloud (Firebase in this case).

Purpose
----
Simple training project to show especially how we can use MVVM-C pattern to create fully functionally iOS application.

Used technologies and approach
----
* Xcode 9.2 (9C40b)
* Swift 4.0
* **MVVM-C** (omitted any 3rd party libraries responsible for data binding, to make to as simple as possible),
* CoreData,
* CoreLocation,
* CocoaPods (manager for 3rd party libraries),
* Firebase for cloud storage (*note: required file GoogleService-Info.plist is not included in the project. To make it work, you have to setup your own Firebase account and add necessary files. For more information follow this guide: https://firebase.google.com/docs/ios/setup*),
* Today Extension (Widget),
* Separate framework (*Shared.framework*) for code sharing for both iOS application and Today Extension.

License
----
The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).