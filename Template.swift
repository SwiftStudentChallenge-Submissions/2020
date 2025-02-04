let _ = Submission(
    name: <#T##String#>,
    status: <#T##Status#>,
    technologies: <#T##[String]#>,
    
    aboutMeUrl: .init(string: <#T##String#>),
    sourceUrl: <#T##URL?#>,
    videoUrl: <#T##URL?#>
)

// MARK: - TEMPLATE - do not remove it //
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
