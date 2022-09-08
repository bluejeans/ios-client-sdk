[![BlueJeans iOS Client Software Development Kit](https://user-images.githubusercontent.com/23289872/127987669-3842046b-2f08-46e4-9949-6bf0cdb45d95.png "BlueJeans iOS Client Software Development Kit Sample App")](https://www.bluejeans.com "BlueJeans iOS Client Software Development Kit")

# HelloBlueJeans
## Welcome to the BlueJeans iOS Client SDK sample application

To run a device you will need

1. Xcode 12.5 or higher
2. A physical device<a href="#notes">(1)</a>, running iOS 13.0 or higher. Setup for development with Xcode.
3. A copy of the latest XCFrameworks for the SDK, linked on Github. The Frameworks folder should be copied into the Samples directory.

Then, click on the HelloBlueJeans project file, go to the HelloBlueJeans target, go to the signing & capabilities tab. Choose your development team, and change the bundle identifier to something unique.

Then navigate to the MeetingController.swift file, go to the method named *join*, and add your meeting ID and passcode.

After that, you should be able to run the app on your device, press the green join button and join your very first BlueJeans meeting from our SDK. You can join the meeting from another device, or invite a friend by giving them your BlueJeans meeting ID and passcode to see the remote video.

## About
This sample app demonstrates how to accomplish the following with the SDK
- Joining and leaving a meeting
- Muting video and audio
- Enabling closed captions
- Display of active speaker
- Uploading of logs
- Receiving content share
- Changing the video layout
- Creating a custom video layout

### Notes
(1) Note, you can use the simulator to develop with the SDK, with some missing features, there are steps in the project README.md for setting this up.
