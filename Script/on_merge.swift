//
//  on_merge.swift
//
//  A simple script to process files and generate a generated.swift file.
//  It's not supposed to be pretty, it's supposed to work. 😉
//
//  Created by Piotr Jeremicz on 4.02.2025.
//

import Foundation

// MARK: - Constants
let submissionsDirectoryName = "Submission"
let templatePrefix = #"""
/// The submission model that represents the application sent by the challenge participant
/// - Parameters:
///   - name: Your name (e.g. John Appleseed)
///   - status: Enum with three values: submitted, accepted, rejected
///   - technologies: Array of String Elements with framework names (e.g. `["SwiftUI", "RealityKit", "CoreGraphic"]`)
///   - aboutMeURLString: Absolute String representing URL, the webpage about you (e.g. `"https://linkedin.com/in/johnappleseed")
///   - sourceURLString: Absolute String representing URL, source code of your project (e.g. `"https://github.com/johnappleseed/wwdc2025"`)
///   - videoURLString: Absolute String representing URL, youtube video about your project (e.g. `"https://youtu.be/H4da5dqhcxY"`)
struct Submission {
    let name: String
    let status: Status
    let technologies: [String]
    
    let aboutMeURLString: String?
    let sourceURLString: String
    let videoURLString: String?
    
    enum Status {
        case submitted, accepted, rejected
    }
}

"""#

let templateSuffix = #"""
let _ = Submission(
    name: <#T##String#>,
    status: <#T##Status#>,
    technologies: <#T##[String]#>,
    
    aboutMeURLString: <#T##String?#>,
    sourceURLString: <#T##String?#>,
    videoURLString: <#T##String?#>
)
"""#

// MARK: - Script
let fileManager = FileManager.default
let rootFiles = (try? fileManager.contentsOfDirectory(atPath: ".")) ?? []
let applicationFiles = rootFiles.filter { $0.hasSuffix(".swift") }

if !fileManager.fileExists(atPath: submissionsDirectoryName) {
    try? fileManager.createDirectory(atPath: submissionsDirectoryName, withIntermediateDirectories: true, attributes: nil)
}

for file in applicationFiles {
    guard !file.contains("Template.swift") else { continue }
    guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
    
    let modifiedContent = content.replacingOccurrences(of: templatePrefix, with: "")
    try? modifiedContent.write(toFile: "\(submissionsDirectoryName)/\(file)", atomically: true, encoding: .utf8)
    try? fileManager.removeItem(atPath: "\(file)")
}

// MARK: - Generator

let generatedPrefix = #"""
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

"""#

let generatedSuffix = #"""

].sorted { $0.name < $1.name}

submissionsCount = submissions.count
acceptedCount = submissions.filter { $0.status == .accepted }.count

let readMe = header + submissions.sorted(by: { $0.name < $1.name}).map(\.row).joined(separator: "\n")
print(readMe)
"""#

let submissionFiles = (try? fileManager.contentsOfDirectory(atPath: submissionsDirectoryName)) ?? []

var submissions = [String]()
for file in submissionFiles {
    guard let content = try? String(contentsOfFile: "Submission/\(file)", encoding: .utf8) else { continue }
    guard !content.isEmpty, content.contains("Submission(") else { continue }
    
    let modifiedContent = content
        .replacingOccurrences(of: "let _ = ", with: "")
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: "    ", with: "")
        .split(separator: ",")
        .joined(separator: ", ")
    
    submissions.append("    " + modifiedContent)
}

let generatedFile = generatedPrefix + submissions.joined(separator: ",\n") + generatedSuffix
try? generatedFile.write(toFile: "Script/generated.swift", atomically: true, encoding: .utf8)

let newTemplateFile = templatePrefix + templateSuffix
try? newTemplateFile.write(toFile: "Template.swift", atomically: true, encoding: .utf8)
