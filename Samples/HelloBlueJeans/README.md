Welcome to the HelloBlueJeans sample application.

To run a device you will need

1 - Xcode 12.5
2 - A physical device (1), running iOS 13.0 or up. Setup for development with Xcode.
3 - A copy of the lastest XCFrameworks for the SDK, linked on Github. The frameworks folder should be copied into the Samples directory.

Then, click on the HelloBlueJeans project file, go to the HelloBlueJeans target, go to the signing and capabilities tab. Choose your developent team, and change the bundle identifier to something unique.

Then navigate to the ViewController.swift file, to the method named *join* and add your own meeting ID and passcode.

After that you should be able to run the app on your own device, press the green join button and join your very first BlueJeans meeting from our SDK. You can join the meeting from another device, or invite a friend by giving them your BlueJeans meeting ID and passcode to see remote video.


(1) Note, you can use the simulator to develop with the SDK, with some missing features, there are steps in the project README.md for setting this up.
