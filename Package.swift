
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
            name: "bluejeans-ios-client-sdk",dependencies: [ "dvclient", "Reachability", "VZXRCVCommon", "VZXRCVVideoEffects", "VZXRCVFeatureVirtualBackgrounds", "BJNiOSBroadcastExtension", "BJNClientCore", "dvdnr", "BJNClientBaseCore", "bjnmediacapturer", "PubNubSpace", "PubNub", "BJNAPIClient", "Swinject", "SocketRocket", "fiberClient", "PubNubMembership", "BJNHTTP", "koko", "fiber", "Mixpanel", "BJNiOSCore", "PubNubUser", "BJNClientSDK", "videoeffects", "MMWormhole", "CocoaLumberjackSwift", "CocoaLumberjack",]),        .target(
            name: "bluejeans-ios-client-sdk-simulator",dependencies: [ "dvclient", "Reachability", "BJNiOSBroadcastExtension", "BJNClientCore", "dvdnr", "BJNClientBaseCore", "bjnmediacapturer", "PubNubSpace", "PubNub", "BJNAPIClient", "Swinject", "SocketRocket", "fiberClient", "PubNubMembership", "BJNHTTP", "koko", "fiber", "Mixpanel", "BJNiOSCore", "PubNubUser", "BJNClientSDK", "videoeffects", "MMWormhole", "CocoaLumberjackSwift", "CocoaLumberjack",]),        .binaryTarget(name: "dvclient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/dvclient.zip", checksum: "23a8efcd81eda42ed3bcaacc2a179a93cbcd51531ab6bd313c58deee97bdaae7"),
        .binaryTarget(name: "Reachability", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/Reachability.zip", checksum: "4e534825cff97ded8d2a2a58820c19e81243e9f3c4eea7a3ba214abd2bb65996"),
        .binaryTarget(name: "VZXRCVCommon", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/VZXRCVCommon.zip", checksum: "1cc2ba20d30ae5048a1c197d78d64f1b558d0bc18611f0358131cf919ac8d50a"),
        .binaryTarget(name: "VZXRCVVideoEffects", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/VZXRCVVideoEffects.zip", checksum: "60cefe4afb121bb84eb3ac901ce98d9f2cb07e1151bf7fe09280f92b076fe62d"),
        .binaryTarget(name: "VZXRCVFeatureVirtualBackgrounds", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/VZXRCVFeatureVirtualBackgrounds.zip", checksum: "8ae5b7f3d73e3a5c9dd05b6fccd59f807e3bdc90b49487e1b4e115dddbea47a1"),
        .binaryTarget(name: "BJNiOSBroadcastExtension", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNiOSBroadcastExtension.zip", checksum: "ee7430429e0bf1d8b6fca913e7d833b252589f69c7c95406a2384df233fee65e"),
        .binaryTarget(name: "BJNClientCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNClientCore.zip", checksum: "6a2dfa7a6433b84141cc9bf2746caedfd89dce7306cda976a54c914371804f0e"),
        .binaryTarget(name: "dvdnr", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/dvdnr.zip", checksum: "376ce7ad47f56eaccc1a9f05c00681ab41f403376f966182858b0b19a96447e5"),
        .binaryTarget(name: "BJNClientBaseCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNClientBaseCore.zip", checksum: "f859ed96282dea239ad736395888f36abac9f67bb6aa726d40f02a73ad316d43"),
        .binaryTarget(name: "bjnmediacapturer", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/bjnmediacapturer.zip", checksum: "a011143e759cc4c4986606736e9d56d7d17359b0a4d0bd005565c283c2519a4c"),
        .binaryTarget(name: "PubNubSpace", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/PubNubSpace.zip", checksum: "b0c822fbf2f7e189405aab0bdbe7d89b59674a71ccebb023e7d5e4ff0d4ef469"),
        .binaryTarget(name: "PubNub", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/PubNub.zip", checksum: "1fb4ece5bf9e9ab58709b2e533ce9d774c7bb2baef1fc6019491484be6f07313"),
        .binaryTarget(name: "BJNAPIClient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNAPIClient.zip", checksum: "cdf9be37b94660c82b8f9a1175ed95031c613c3e1fae3a51af23d82a2c7985ab"),
        .binaryTarget(name: "Swinject", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/Swinject.zip", checksum: "0f5bd5165f54e489ec2db8502564607823f39611a14a01071dc2a3fac8aee862"),
        .binaryTarget(name: "SocketRocket", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/SocketRocket.zip", checksum: "bbb2974bf6f9f6cf6129bad107afff84669a6228d8490c3458fe95e28e36cdd9"),
        .binaryTarget(name: "fiberClient", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/fiberClient.zip", checksum: "2e6ac81b2c7b0d2342caf39555843119550a7c8db560d6c97c0385677330da68"),
        .binaryTarget(name: "PubNubMembership", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/PubNubMembership.zip", checksum: "2573b0997e40fc53efa204f4c4dc2018a159df919a727551da15e0498aa03dbe"),
        .binaryTarget(name: "BJNHTTP", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNHTTP.zip", checksum: "558c163c8f7653a9d966a1fdec39096332a9113367c0cd6494fcb6965c7225ca"),
        .binaryTarget(name: "koko", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/koko.zip", checksum: "c0fcaceb8c78c905f58df534e966cfbeee2cc64ef37c8a0681412c3cd79ebd60"),
        .binaryTarget(name: "fiber", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/fiber.zip", checksum: "55dc4e4d3e43ed89a5170ca7b9aef422a89692ddda74c88a82032261f375a2d6"),
        .binaryTarget(name: "Mixpanel", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/Mixpanel.zip", checksum: "a56a7e841ac9332eeb8171d104e99db0ed81a17c2d4db2d1928745ec10e316e3"),
        .binaryTarget(name: "BJNiOSCore", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNiOSCore.zip", checksum: "932eb4173799d689c35fb407f8cf9bbba2feda0f5bc3b11f2b713d3ab1a248ce"),
        .binaryTarget(name: "PubNubUser", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/PubNubUser.zip", checksum: "501ecdd8bc22b92021052d3ade7f8180a7ecb38e060c113c3db96d4cc756e932"),
        .binaryTarget(name: "BJNClientSDK", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/BJNClientSDK.zip", checksum: "f47e3b0346ae35c142b9dd09fff56232f87f9800feaf7f345635cc70a8b15c1c"),
        .binaryTarget(name: "videoeffects", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/videoeffects.zip", checksum: "bc41c48c6b1bc3a9548449905351adc68d7800b3ae4a63a2c7bbb3f178fddfbc"),
        .binaryTarget(name: "MMWormhole", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/MMWormhole.zip", checksum: "755c61a4644d28f350fd5ba4f23640a056b39a666b436fd1186608b3a5bbf252"),
        .binaryTarget(name: "CocoaLumberjackSwift", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/CocoaLumberjackSwift.zip", checksum: "9788ab45dcbc83182bb2a80bc0ee646ae45c0b0cdf2eb54a7b81ed1c15f8b52e"),
        .binaryTarget(name: "CocoaLumberjack", url: "https://swdl.bluejeans.com/bjnvideosdk/ios/1.8.0/SPM_Frameworks/CocoaLumberjack.zip", checksum: "52755bac86c58542afa5c4b24625af0d5beea108d90328b88ccbb0186751686a"),    ]
)

