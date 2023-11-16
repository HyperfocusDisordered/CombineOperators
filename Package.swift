// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "CombineOperators",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13),
    ],
    products: [
			.library(name: "CombineOperators", targets: ["CombineOperators"]),
    ],
    dependencies: [
			.package(url: "https://github.com/HyperfocusDisordered/FoundationExtensions.git", revision: "7d9864e3d59c342825b9a09fc23b8fc240b8fa71"),
    ],
    targets: [
			.target(name: "CombineOperators", dependencies: ["FoundationExtensions"]),
    ]
)
