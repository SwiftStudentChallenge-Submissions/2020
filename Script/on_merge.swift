import Foundation

// MARK: - Constants
let submissionsDirectoryName = "Submission"
let templatePrefix = "let _ = "
let templateSuffix = """

// MARK: - TEMPLATE, leave it as it is
struct Submission {
    let name: String
    let status: Status
    let technologies: [String]
    
    let aboutMeUrl: URL?
    let sourceUrl: URL?
    let videoUrl: URL?
    
    enum Status {
        case submitted, accepted, rejected
    }
}
"""

// MARK: - Script
let fileManager = FileManager.default
let rootFiles = (try? fileManager.contentsOfDirectory(atPath: ".")) ?? []
let applicationFiles = rootFiles.filter { $0.hasSuffix(".swift") }

for file in applicationFiles {
    guard let content = try? String(contentsOfFile: file, encoding: .utf8) else { continue }
    
    let modifiedContent = content
        .replacingOccurrences(of: templatePrefix, with: "")
        .replacingOccurrences(of: templateSuffix, with: "")
        .replacingOccurrences(of: "\n\n", with: "")
    
    
    try? modifiedContent.write(toFile: "\(submissionsDirectoryName)/\(file)", atomically: true, encoding: .utf8)
    try? fileManager.removeItem(atPath: "\(file)")
}

// MARK: - Generator

let generatedPrefix = #"""
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
        .replacingOccurrences(of: "\n", with: "")
        .replacingOccurrences(of: "    ", with: "")
        .split(separator: ",")
        .joined(separator: ", ")
    
    submissions.append("    " + modifiedContent)
}

let generatedFile = generatedPrefix + submissions.joined(separator: ",\n") + generatedSuffix
try? generatedFile.write(toFile: "Script/generated.swift", atomically: true, encoding: .utf8)
