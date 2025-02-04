import Foundation

let year = 2020

var submissionsCount: Int = 0
var acceptedCount: Int = 0
var header: String {
"""
# WWDC \(year) - Swift Student Challenge
![WWDC2019 Logo](logo.png)

List of student submissions for the WWDC \(year) Swift Student Challenge.

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