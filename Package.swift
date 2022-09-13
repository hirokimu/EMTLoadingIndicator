// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "EMTLoadingIndicator",
    platforms: [
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "EMTLoadingIndicator",
            targets: ["EMTLoadingIndicator"])
    ],
    targets: [
        .target(
            name: "EMTLoadingIndicator",
            path: ".",
            exclude: ["LICENSE",
                      "README.md",
                      "waitIndicatorGraphic.fla",
                      "EMTLoadingIndicator/Info.plist",
                      "EMTLoadingIndicator.podspec"],
            sources: ["EMTLoadingIndicator/Classes"],
            resources: [.process("EMTLoadingIndicator/Resources")])
    ]
)
