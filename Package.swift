
import PackageDescription

let package = Package(
    name: "Erratic",
    dependencies: [
        .Package(url: "https://github.com/JadenGeller/Permute.git", majorVersion: 1)
    ]
)
