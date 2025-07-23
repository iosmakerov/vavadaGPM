import Foundation
struct PitchSessionData {
    let startupName: String
    let logoCreated: Bool
    let problemStatement1: String
    let problemStatement2: String
    let ourSolution1: String
    let ourSolution2: String
    let whyNow1: String
    let whyNow2: String
    let callToAction1: String
    let callToAction2: String
    var primaryProblemStatement: String {
        return !problemStatement1.isEmpty ? problemStatement1 : problemStatement2
    }
    var primarySolution: String {
        return !ourSolution1.isEmpty ? ourSolution1 : ourSolution2
    }
    var primaryWhyNow: String {
        return !whyNow1.isEmpty ? whyNow1 : whyNow2
    }
    var primaryCallToAction: String {
        return !callToAction1.isEmpty ? callToAction1 : callToAction2
    }
    var isComplete: Bool {
        return !startupName.isEmpty &&
               (!problemStatement1.isEmpty || !problemStatement2.isEmpty) &&
               (!ourSolution1.isEmpty || !ourSolution2.isEmpty) &&
               (!whyNow1.isEmpty || !whyNow2.isEmpty) &&
               (!callToAction1.isEmpty || !callToAction2.isEmpty)
    }
    var completionScore: Double {
        var score: Double = 0
        let maxScore: Double = 10
        if !startupName.isEmpty { score += 2 }
        if !primaryProblemStatement.isEmpty { score += 2 }
        if !primarySolution.isEmpty { score += 2 }
        if !primaryWhyNow.isEmpty { score += 2 }
        if !primaryCallToAction.isEmpty { score += 2 }
        return min(score / maxScore, 1.0)
    }
}
extension PitchSessionData {
    func toPitchHistory(rating: Int) -> PitchHistory {
        return PitchHistory(
            startupName: startupName,
            problemStatement: primaryProblemStatement,
            solution: primarySolution,
            whyNow: primaryWhyNow,
            callToAction: primaryCallToAction,
            rating: rating
        )
    }
}