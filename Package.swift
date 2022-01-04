// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "EMTLoadingIndicator",
    platforms: [
        .watchOS(.v3)
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
            sources: ["EMTLoadingIndicator/Classes"],
            resources: [.process("EMTLoadingIndicator/Resources")])
    ]
)