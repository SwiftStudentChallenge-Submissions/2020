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

let _ = Submission(
    name: <#T##String#>,
    status: <#T##Status#>,
    technologies: <#T##[String]#>,
    
    aboutMeURLString: <#T##String?#>,
    sourceURLString: <#T##String?#>,
    videoURLString: <#T##String?#>
)
