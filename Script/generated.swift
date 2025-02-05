//
//  generated.swift
//
//  A simple script to generate a README.md file.
//  It's not supposed to be pretty, it's supposed to work. 😉
//
//  Created by Piotr Jeremicz on 4.02.2025.
//

import Foundation

let year = 2020
let name = "Swift Student Challenge"
var header: String {
"""
# WWDC \(year) - \(name)
![WWDC\(year) Logo](logo.png)

List of student submissions for the WWDC \(year) - \(name).

### How to add your submission?
1. [Click here](https://github.com/SwiftStudentChallenge-Submissions/\(year)/edit/main/Template.swift) to edit `Template.swift` file
2. Fill the `Submission` initializer with provided documentation
3. Rename file with your name (f.e. johnappleseed.swift)
3. Make new Pull Request and wait for the review

### Submissions

Submissions: \(submissionsCount)\\
Accepted: \(acceptedCount)

| Name | Source |    Video    | Technologies | Status |
|-----:|:------:|:-----------:|:-------------|:------:|

"""
}

var submissionsCount: Int = 0
var acceptedCount: Int = 0

struct Submission {
    let name: String
    let status: Status
    let technologies: [String]
    
    let aboutMeURLString: String?
    let sourceURLString: String
    let videoURLString: String?
    
    enum Status: String {
        case submitted = "Submitted"
        case accepted = "Accepted"
        case rejected = "Rejected"
        
        var iconURLString: String {
            switch self {
            case .submitted:
                "https://img.shields.io/badge/submitted-grey?style=for-the-badge"
            case .accepted:
                "https://img.shields.io/badge/accepted-green?style=for-the-badge"
            case .rejected:
                "https://img.shields.io/badge/rejected-firebrick?style=for-the-badge"
            }
        }
    }
    
    var row: String {
        let nameRow = if let aboutMeUrl = URL(string: aboutMeURLString ?? "") {
            "[\(name)](\(aboutMeUrl.absoluteString))"
        } else {
            "\(name)"
        }
        
        let sourceRow: String = if let sourceUrl = URL(string: sourceURLString) {
            "[GitHub](\(sourceUrl.absoluteString))"
        } else {
            "-"
        }
        
        let videoUrl = if let videoUrl = URL(string: videoURLString ?? "") {
            "[YouTube](\(videoUrl.absoluteString))"
        } else {
            "-"
        }
        
        let technologiesRow = technologies.joined(separator: ", ")
        
        let statusRow: String = "![\(status.rawValue)](\(status.iconURLString))"
        
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
    Submission(name: "Piotrek Jeremicz", status: .accepted, technologies: ["UIKit",  "AVKit",  "AVFoundation"], aboutMeURLString: "https://github.com/piotrekjeremicz", sourceURLString: "https://github.com/piotrekjeremicz", videoURLString: "https://youtu.be/H4da5dqhcxY"),
    Submission(name: "Jan Kowalski", status: .rejected, technologies: ["UIKit"], aboutMeURLString: "www.example.com", sourceURLString: "www.example.com", videoURLString: "www.example.com")
].sorted { $0.name < $1.name}

submissionsCount = submissions.count
acceptedCount = submissions.filter { $0.status == .accepted }.count

let readMe = header + submissions.sorted(by: { $0.name < $1.name}).map(\.row).joined(separator: "\n")
print(readMe)