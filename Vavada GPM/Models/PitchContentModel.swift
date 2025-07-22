import Foundation

// MARK: - Startup Names
struct StartupNameData {
    static let names = [
        "SnoutStack",
        "Oinkr",
        "GruntHub",
        "PigPal Pay",
        "Swinefluence"
    ]
    
    static func getRandomName() -> String {
        return names.randomElement() ?? "SnoutStack"
    }
}

// MARK: - Pitch Content
struct PitchContentData {
    
    // Problem Statement варианты
    static let problemStatements = [
        "Traditional finance excludes pigs with passion.",
        "Modern life lacks bacon transparency.",
        "Crypto is confusing, even for technophile swine.",
        "Snacking is outdated and non-gamified."
    ]
    
    // Our Solution варианты
    static let ourSolutions = [
        "A decentralized oinkchain powered by noseprint ID.",
        "We connect piggy micro-brands directly to audiences.",
        "An AI-powered app that gamifies bacon delivery.",
        "Snout-to-snout payment tech for rural banking."
    ]
    
    // Why Now варианты
    static let whyNowReasons = [
        "Porktech is trending, and we're riding the trough.",
        "In a post-oinkdemic world, trust is digital.",
        "Consumer behavior is shifting toward edible NFTs.",
        "Investor sentiment is ripe for ironic disruption."
    ]
    
    // Call to Action варианты
    static let callToActions = [
        "Join the herd. Back Swinefluence today.",
        "Become a founding bacon-naire.",
        "Oink less, earn more.",
        "Let's squeal together — and monetize it."
    ]
    
    // Методы для получения случайного варианта
    static func getRandomProblemStatement() -> String {
        return problemStatements.randomElement() ?? problemStatements[0]
    }
    
    static func getRandomSolution() -> String {
        return ourSolutions.randomElement() ?? ourSolutions[0]
    }
    
    static func getRandomWhyNow() -> String {
        return whyNowReasons.randomElement() ?? whyNowReasons[0]
    }
    
    static func getRandomCallToAction() -> String {
        return callToActions.randomElement() ?? callToActions[0]
    }
}

// MARK: - Result Messages
struct ResultMessageData {
    
    struct ResultMessage {
        let title: String
        let message: String
        let description: String
    }
    
    static let oneToTwoStars = ResultMessage(
        title: "Rejection",
        message: "We're out. The market isn't ready for this... or maybe it's just awful. Please return the whiteboard.",
        description: "Investor swipes left with visible nausea."
    )
    
    static let threeStars = ResultMessage(
        title: "Polite Pass / Room to Grow", 
        message: "Interesting concept, but we need to see traction… or a working product. Or a real pig.",
        description: "Investor claps awkwardly, gives a coin, then checks phone."
    )
    
    static let fourToFiveStars = ResultMessage(
        title: "Funding Success",
        message: "We love it. The branding. The buzzwords. The bacon. You've got yourself a term sheet, piggy!",
        description: "Confetti falls. App shows ICP gain and \"Pre-Unicorn Status: Pending.\""
    )
    
    static func getMessage(for stars: Int) -> ResultMessage {
        switch stars {
        case 1, 2:
            return oneToTwoStars
        case 3:
            return threeStars
        case 4, 5:
            return fourToFiveStars
        default:
            return threeStars
        }
    }
}

// MARK: - Market Simulator Content
struct MarketSimulatorData {
    static let description = "Track real-time chaos across the piggy startup economy. Monitor trends like Crypto, BaconTech, Green Energy, and Snoutfluencing. React to sudden booms, savage crashes, or surprise events like \"Bacon Ban Bill Passed.\"\nStay informed — or get trampled."
    
    static let marketEvents = [
        "Bacon Ban Bill Passed",
        "Oinkchain Fork Announced",
        "Pig IPO Spectacular",
        "Snoutfluencer Scandal",
        "BaconTech Bubble Burst",
        "Green Energy Pig Revolution"
    ]
    
    static func getRandomEvent() -> String {
        return marketEvents.randomElement() ?? "Market volatility continues"
    }
} 