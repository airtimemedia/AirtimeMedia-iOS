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
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F2.0/3/AirtimeMedia.xcframework.zip",
            checksum: "d99714c9b527f975a60d9dc0fd251ebb4f57388dac379f3eeb4c920c4d9bd80d"
        ),
        .binaryTarget(
            name: "Bakersfield",
            url: "https://airtime-eng-asilomar-libs.s3-accelerate.amazonaws.com/jobs/airtimemedia/asilomar/release%252F2.0/3/Bakersfield.xcframework.zip",
            checksum: "12a984c93674353d94be3ce030fdf04848c503d61779d24ed77bc0e140987fe2"
        ),
    ]
)
