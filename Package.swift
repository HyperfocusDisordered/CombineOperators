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

        .package(url: "https://github.com/HyperfocusDisordered/FoundationExtensions.git", .exact("2.12.0")),
    ],
    targets: [
			.target(name: "CombineOperators", dependencies: ["FoundationExtensions"]),
    ]
)
