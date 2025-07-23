import SwiftUI
struct RulesScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("RULES")
                    .font(FontManager.title)
                    .foregroundColor(ColorManager.white)
                    .fontWeight(.bold)
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.tabBarGradient)
            )
            .padding(.horizontal, 20)
            .padding(.top, 30)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("🐷 Viral Ventures")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                    Text("A ridiculous tabletop game of fake ideas and very questionable investors.")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                    Text("🎯 OBJECTIVE")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    Text("You are a pig with a pitch and a dream. Your goal is to build the funniest, trendiest, or most investor-bait startup and win the most Investor Confidence Points (ICP) before the final round.")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                    Text("👥 PLAYERS")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("3–5 aspiring piggy CEOs")
                        Text("Ages 13+")
                        Text("Playtime: 45–60 minutes")
                        Text("Required: Smartphones or tablets with the Viral Ventures Companion App")
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("📱 COMPANION APP")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    Text("The free Viral Ventures App helps run the game:")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Generates startup names")
                        Text("• Handles pitch steps and logo drawing")
                        Text("• Simulates the market")
                        Text("• Scores investor reactions")
                        Text("• Tracks turns, trends, and ICP")
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("🧩 GAME SETUP")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    Text("Each player receives:")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• 1 Piggy CEO Board")
                        Text("• 3 Coins")
                        Text("• 2 Random Startup Idea Cards")
                        Text("• 2 Action Cards")
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("App Setup:")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                        .padding(.top, 8)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Choose Lobby Mode for multiplayer")
                        Text("• Select player count")
                        Text("• Enable Market Simulator (recommended)")
                        Text("• Decide turn order: Whoever last opened a startup, real or imagined, goes first.")
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("🔁 GAMEPLAY OVERVIEW")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    Text("Each game has 6 rounds. Each round follows these phases:")
                        .font(FontManager.body)
                        .foregroundColor(ColorManager.white)
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🐽 1. BUILD YOUR STARTUP (App Phase)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.primaryRed)
                            Text("Each player takes turns completing 3 app-guided steps:")
                            Text("• Generate a Startup Name (or invent your own)")
                            Text("• Draw a Logo using the in-app finger canvas")
                            Text("• Build Your Pitch using pre-written options (or type your own)")
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🎤 2. PITCH TIME")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.primaryRed)
                            Text("One at a time, players present their pitch aloud or tap 'Submit' for the app to evaluate.")
                            Text("✅ The winner earns 2 ICP, runner-up earns 1 ICP, others earn 0")
                            Text("✅ In case of tie, both tied players earn full points")
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💼 3. ACTION PHASE")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.primaryRed)
                            Text("Each player may play one Action Card, such as:")
                            Text("• Spin It – Gain Hype")
                            Text("• Sabotage – Remove rival Funding")
                            Text("• Pivot – Change your startup category")
                            Text("• Steal Investor – Steal 1 ICP from the leader")
                            Text("Discard after use.")
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("📉 4. MARKET EVENT")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.primaryRed)
                            Text("At the end of each round, tap \"Market Event\" in the app.")
                            Text("This may cause market crashes, trend reversals, or bonus sectors.")
                            Text("Adapt accordingly!")
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("💸 5. FUNDING ROUND")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.primaryRed)
                            Text("All players gain coins equal to their Development level (1–3).")
                            Text("Coins are used for upgrades or bribing investors.")
                        }
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("🏁 ENDGAME: ROUND 6")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("After the final Market Event, tally:")
                        Text("• ICP (Investor Confidence Points)")
                        Text("• Bonus points from Action Cards")
                        Text("• App-generated awards (e.g. \"Most Buzzwords\", \"Best Logo\")")
                        Text("• Leftover coins (1 coin = 0.2 ICP for tie-breakers)")
                        Text("🎉 The piggy with the most ICP wins the Golden Snout Award™ and is crowned CEO of Viral Ventures.")
                    }
                    .font(FontManager.body)
                    .foregroundColor(ColorManager.white)
                    Text("🤔 FREQUENTLY OINKED QUESTIONS")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorManager.primaryRed)
                        .padding(.top, 16)
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Q: Can I just use buzzwords to win the pitch?")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.white)
                            Text("A: You'll probably score well. But style, timing, and delivery matter.")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Q: What if someone doesn't want to draw a logo?")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.white)
                            Text("A: Use the random logo generator or piggy stamp.")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Q: Can I trade ICP or coins?")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ColorManager.white)
                            Text("A: If all players agree, yes. Bribes welcome. (But write it into your next pitch.)")
                                .font(FontManager.body)
                                .foregroundColor(ColorManager.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.35, green: 0.32, blue: 0.45))
            )
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 20)
        }
        .background(
            ColorManager.background
                .ignoresSafeArea(.all)
        )
    }
}
struct RulesScreen_Previews: PreviewProvider {
    static var previews: some View {
        RulesScreen()
    }
}