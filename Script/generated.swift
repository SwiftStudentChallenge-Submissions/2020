import Foundation

let year = 2020

var submissionsCount: Int = 0
var acceptedCount: Int = 0
var header: String {
"""
# WWDC \(year) - Swift Student Challenge
![WWDC\(year) Logo](logo.png)

List of student submissions for the WWDC \(year) Swift Student Challenge.

### How to add your submission?
1. Download file template: [sample_submission.swift](https://github.com)
2. Edit the file in any IDE
3. Rename it with your name (eg. `johnappleseed.swift`)
4. Here, on GitHub choose **Create file** -> **Upload files**
5. Select your file, upload and create Pull Request
6. Wait for review :)

Submissions: \(submissionsCount)\\
Accepted: \(acceptedCount)

| Name | Source |    Video    | Technologies | Status |
|------|--------|-------------|--------------|--------|

"""
}

struct Submission {
    let name: String
    let status: Status
    let technologies: [String]
    
    let aboutMeUrl: URL?
    let sourceUrl: URL?
    let videoUrl: URL?
    
    enum Status: String {
        case submitted = "Submitted"
        case accepted = "Accepted"
        case rejected = "Rejected"
    }
    
    var row: String {
        let nameRow = if let aboutMeUrl {
            "[\(name)](\(aboutMeUrl.absoluteString))"
        } else {
            "\(name)"
        }
        
        let sourceRow: String = if let sourceUrl {
            "[GitHub](\(sourceUrl.absoluteString))"
        } else {
            "-"
        }
        
        let videoUrl = if let videoUrl {
            "[YouTube](\(videoUrl.absoluteString))"
        } else {
            "-"
        }
        
        let technologiesRow = technologies.joined(separator: ", ")
        
        let statusRow: String = status.rawValue
        
        return "|" + [
            nameRow,
            sourceRow,
            videoUrl,
            technologiesRow,
            statusRow
        ].joined(separator: "|") + "|"
    }
}

let submissions: [Submission] = [
    Submission(name: "Piotr Jeremicz", status: .accepted, technologies: ["UIKit",  "AVKit",  "AVFoundation"], aboutMeUrl: .init(string: "https://github.com/piotrekjeremicz"), sourceUrl: nil, videoUrl: .init(string: "https://youtu.be/H4da5dqhcxY"))
].sorted { $0.name < $1.name}

submissionsCount = submissions.count
acceptedCount = submissions.filter { $0.status == .accepted }.count

let readMe = header + submissions.sorted(by: { $0.name < $1.name}).map(\.row).joined(separator: "\n")
print(readMe)