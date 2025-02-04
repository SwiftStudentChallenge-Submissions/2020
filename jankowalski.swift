let _ = Submission(
    name: "Jan Kowalski",
    status: .accepted,
    technologies: ["SwiftUI"],
    
    aboutMeUrl: nil,
    sourceUrl: nil,
    videoUrl: nil
)

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
