// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "CombineOperators",
    platforms: [
        .iOS(.v13)
    ],
    products: [
			.library(name: "CombineOperators", targets: ["CombineOperators"]),
    ],
    dependencies: [
			.package(url: "https://github.com/HyperfocusDisordered/FoundationExtensions.git", revision: "5ecbfe0d3eccb97a8f1f570affcbc7b7673d9a96"),
            .package(url: "https://github.com/HyperfocusDisordered/UIKitExtensions.git", revision: "fc04f7038e2075f4b0f3526048861211084a0931"),
    ],
    targets: [
			.target(name: "CombineOperators", dependencies: ["FoundationExtensions", "UIKitExtensions"]),
    ]
)
