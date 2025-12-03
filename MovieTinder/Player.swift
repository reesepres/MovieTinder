import SwiftUI

private let pink = Color(red: 225/225, green: 192/255, blue: 203/225)
// testing Github Subscription to Slack
struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let Color1 = Color(hex: "B5E4EA")
    let Color2 = Color(hex: "9BF6FF")
    let Color3 = Color(hex: "FCF0D6")
    let Color4 = Color(hex: "FEDEE2")
    let Color5 = Color(hex: "FBD5B0")
    let Color6 = Color(hex: "D9F1F3")
    let Color7 = Color(hex: "C2A9EF")
    let Color8 = Color(hex: "EFBBF0")
    let colors: [Color] = [Color2, Color7, Color3, Color4, Color5, Color6, Color1,Color8]
//    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .teal, pink]
    return (0..<count).map { i in
        Player(id: i, color: colors[i % colors.count])
    }
}
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}


