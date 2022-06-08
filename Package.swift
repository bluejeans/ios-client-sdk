
// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
// THIS FILE IS AUTOGENERATED

import PackageDescription

let package = Package(
    name: "bluejeans-ios-client-sdk",

    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "bluejeans-ios-client-sdk",
            targets: ["bluejeans-ios-client-sdk"]),
        .library(
            name: "bluejeans-ios-client-sdk-simulator",
            targets: ["bluejeans-ios-client-sdk-simulator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "bluejeans-ios-client-sdk",dependencies: [ "dvclient", "Reachability", "VZXRCVCommon", "VZXRCVVideoEffects", "VZXRCVFeatureVirtualBackgrounds", "BJNiOSBroadcastExtension", "BJNClientCore", "BJNClientBaseCore", "bjnmediacapturer", "PubNub", "BJNAPIClient", "Swinject", "SocketRocket", "fiberClient", "BJNHTTP", "koko", "fiber", "Mixpanel", "BJNiOSCore", "BJNClientSDK", "videoeffects", "MMWormhole", "CocoaLumberjackSwift", "CocoaLumberjack",]),        .target(
            name: "bluejeans-ios-client-sdk-simulator",dependencies: [ "dvclient", "Reachability", "BJNiOSBroadcastExtension", "BJNClientCore", "BJNClientBaseCore", "bjnmediacapturer", "PubNub", "BJNAPIClient", "Swinject", "SocketRocket", "fiberClient", "BJNHTTP", "koko", "fiber", "Mixpanel", "BJNiOSCore", "BJNClientSDK", "videoeffects", "MMWormhole", "CocoaLumberjackSwift", "CocoaLumberjack",]),        .binaryTarget(name: "dvclient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/dvclient.zip", checksum: "e4566c67cf914e6f7a781bdad04a1c1dc55a4c7e338317332335f8513c67c859"),
        .binaryTarget(name: "Reachability", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/Reachability.zip", checksum: "783f3104e085ad000d7e2c14e9c6c1b395d9cdfb4ba484bc701b69b762388b26"),
        .binaryTarget(name: "VZXRCVCommon", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/VZXRCVCommon.zip", checksum: "4271968982e17009e4d2d122b40e394acf13bc53735e4403c066082d51b525ab"),
        .binaryTarget(name: "VZXRCVVideoEffects", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/VZXRCVVideoEffects.zip", checksum: "e9a119b778f52b557935b9ae9b0fef1e4d3bc5215d63763b30eeca1343ba1814"),
        .binaryTarget(name: "VZXRCVFeatureVirtualBackgrounds", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/VZXRCVFeatureVirtualBackgrounds.zip", checksum: "99dd3a87ac88aa201eec0916411f08d7916381c1969ce05e753c9380be314b11"),
        .binaryTarget(name: "BJNiOSBroadcastExtension", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNiOSBroadcastExtension.zip", checksum: "0c8c607d3ae0359e546bcbd5080412e1eaed7e145e1d9c25cefc76a37b6fba5e"),
        .binaryTarget(name: "BJNClientCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNClientCore.zip", checksum: "9cea739f655f78821c95884c61479ea78a4c5426a4dc4ecb591be0b34475e13f"),
        .binaryTarget(name: "BJNClientBaseCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNClientBaseCore.zip", checksum: "fd73232a2d83a113937911cf615de9a41a526a63b4c124199e85d07687b843a4"),
        .binaryTarget(name: "bjnmediacapturer", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/bjnmediacapturer.zip", checksum: "5b54966a1211b6f2ef6817a3b59bccbd3f1a376425e1eb9e21ac8c2ac7da89f6"),
        .binaryTarget(name: "PubNub", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/PubNub.zip", checksum: "9e98c97a989282ec8c6e8a8fd3078ddcbc5470d7f715935799504eac8ac4ab25"),
        .binaryTarget(name: "BJNAPIClient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNAPIClient.zip", checksum: "d732d4c5467cf2fbff5ada3e2b19dd991b0b1a574a30ab0aef7a4ec9cf91faaf"),
        .binaryTarget(name: "Swinject", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/Swinject.zip", checksum: "432456381d2f0c1a949e3aa0c73e53078ce5223ce49d1eea2d99be868a00d4ba"),
        .binaryTarget(name: "SocketRocket", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/SocketRocket.zip", checksum: "8d0f82f122c0ea0c76f2a363f8fd8cfb8f67eb9f640da484b433cd8f5f8c168a"),
        .binaryTarget(name: "fiberClient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/fiberClient.zip", checksum: "9e60a4cffb4aaa65c20e94042ef496949e6f632115a5498bbefd1192475d3b88"),
        .binaryTarget(name: "BJNHTTP", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNHTTP.zip", checksum: "1e58e8908f417839392f6de1641e4c6c928c0b57d6f33f5d70fe3a155cad860a"),
        .binaryTarget(name: "koko", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/koko.zip", checksum: "ee041eec014636f216a2e08cec9ee2512657fe2863e79358a2d3995211287ba9"),
        .binaryTarget(name: "fiber", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/fiber.zip", checksum: "bbf12d038359f26bf7237532de7173bc3e8775c937daa292b351968df8a5d7e3"),
        .binaryTarget(name: "Mixpanel", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/Mixpanel.zip", checksum: "82883f388953a0fc20b36212a35c6363dda89573a53929b19c0cb0b834dc4f05"),
        .binaryTarget(name: "BJNiOSCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNiOSCore.zip", checksum: "bcd2c5b1aa604d070eb621950dfac793d5cb525d1d09275523e5fd10a2185b05"),
        .binaryTarget(name: "BJNClientSDK", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/BJNClientSDK.zip", checksum: "80aa335e77f4b96fa4fb9e585635441e7867ff6d7f12dce2be02dc2500f69b58"),
        .binaryTarget(name: "videoeffects", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/videoeffects.zip", checksum: "6f09bff5ce71f49407c1f73a4245dfafe5c35a4543f66ad153c4b2384b17a00c"),
        .binaryTarget(name: "MMWormhole", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/MMWormhole.zip", checksum: "b8d9ca09ab9f32784cb2257d7fde78782777f5234f28a90ff510f53787d7ed66"),
        .binaryTarget(name: "CocoaLumberjackSwift", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/CocoaLumberjackSwift.zip", checksum: "2fbc4381749801acd515e1799488da92ce2f0d54cd59cd4c83d2a3ff5bc8d1fa"),
        .binaryTarget(name: "CocoaLumberjack", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.5.0/SPM_Frameworks/CocoaLumberjack.zip", checksum: "9b56cca65af3b8b6c068f367b583deceeeed9e2e23d34db40f5260080db61b79"),    ]
)

