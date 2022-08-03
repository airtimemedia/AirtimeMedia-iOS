// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AirtimeMedia",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AirtimeMedia",
            targets: ["AirtimeMedia", "Bakersfield"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "AirtimeMedia",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.4/3/AirtimeMedia.xcframework.zip",
            checksum: "70d956e78d4e324c4f23150f1e6f3d644e7e4a518c4313f2ed5949e956c90d36"
        ),
        .binaryTarget(
            name: "Bakersfield",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.4/3/Bakersfield.xcframework.zip",
            checksum: "39ee278803098c1d568856d0e5840ecd448dd6bc0449c9a9fbe9ee45918c59e7"
        ),
    ]
)
