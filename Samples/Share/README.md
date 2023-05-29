[![BlueJeans iOS Client Software Development Kit](https://user-images.githubusercontent.com/23289872/127987669-3842046b-2f08-46e4-9949-6bf0cdb45d95.png "BlueJeans iOS Client Software Development Kit Sample App")](https://www.bluejeans.com "BlueJeans iOS Client Software Development Kit")

Welcome to the "Share" sample application. This is a barebone sample application to show you how you can share the screen with the BlueJeansSDK.

To run a device you will need:

1. A Mac running Xcode 14.1, or higher.
2. A physical device, running iOS 14.0 or higher. Setup for development with Xcode.
3. A copy of the latest XCFrameworks for the SDK, linked on Github. The *Frameworks* folder should be copied into the Samples directory. Use the appropriate frameworks for the version of Xcode you are using.

Then, click on the Share project file, go to the Share target, go to the signing and capabilities tab. Choose your development team, and change the bundle identifier to something unique.

You will have to set up the undle identifiers and app groups to allow the app to run on your device, and for the extension and app to communicate. Detailed instructions are given in the ContentSharingGuide.md guide. Steps you need to take are:

- Change the app bundle identifier to a unique value
- Change the app extension bundle identifier to a unique value
- Under app groups for the app target, click the checkbox to remove the app group there. Then add a new group with a unique string.
- Under app groups for the extension target, click the checkbox to remove the app group there. Then add a new group with the same string as for the app.
- Under the Info.plist for the app, there are two values
        - Change BJNScreenSharingAppGroup to the identifier of the app group you created.
        - Change BJNScreenSharingBundleID to the bundle ID of the app extension.
- Under the Info.plist for the extension:
        - Change the BJNScreenSharingAppGroup to the identifier of the app group you created.
- Under the `addRPSystemBroadcastPickerView` function, change the `pickerView.preferredExtension` value to the bundle identifier of the extension.
- In the `viewDidLoad` method of the ViewController.swift file, in the meetingService.join call. Add your meeting ID and passcode, details for getting one of these can be found in the getting started guide.

After that, you should be able to run the app on your device, press the green join button and join a BlueJeans meeting. You can join the meeting from another device, or invite a friend by giving them your BlueJeans meeting ID and passcode to see the remote video. If the screen turns gray but you don't see a button to share the screen, screen share may be unavailable for some reason. Try joining the meeting on another device with the BlueJeans app to see if this is the case.
