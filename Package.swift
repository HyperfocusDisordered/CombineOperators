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
			.library(name: "CombineCocoa", targets: ["CombineCocoa"])
    ],
    dependencies: [
			.package(url: "https://github.com/HyperfocusDisordered/VDKit.git", revision: "f3b617a3d359b440c0f45d06f51162c0313f256c"),
    ],
    targets: [
			.target(name: "CombineOperators", dependencies: ["VDKit"]),
			.target(name: "CombineCocoa", dependencies: ["CombineOperators", "VDKit"]),
			.testTarget(name: "CombineOperatorsTests", dependencies: ["CombineOperators", "CombineCocoa"])
    ]
)
