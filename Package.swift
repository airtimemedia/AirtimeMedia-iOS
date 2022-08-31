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
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.5/2/AirtimeMedia.xcframework.zip",
            checksum: "b5e0a0992da4c569465f53e0e8c96a8ed3b8f76139d948a3c7f59181e0cf62c4"
        ),
        .binaryTarget(
            name: "Bakersfield",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F1.5/2/Bakersfield.xcframework.zip",
            checksum: "0ce55e3f564e740f48590476022de7d5493cadf922572733bca1b1d9b4b33a10"
        ),
    ]
)
