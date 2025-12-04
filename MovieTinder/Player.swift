import SwiftUI

private let pink = Color(red: 225/225, green: 192/255, blue: 203/225)
// testing Github Subscription to Slack
struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let Color1 = Color(hex: "FBA8B6") //orangish-pink
    let Color2 = Color(hex: "C7DEFA") //BLUE
    let Color3 = Color(hex: "CF9BDD") //DARK PURPLE
    let Color4 = Color(hex: "FFD6AE") //CREAMY PEACH
    let Color5 = Color(hex: "FFD9F2") //ROSEWATER GLOW
    let Color6 = Color(hex: "A2E4E2") //SEAFOAM MIST
    let Color7 = Color(hex: "E6CCFF") //LAVENDAR COTTON
    let Color8 = Color(hex: "FFCC99") //PASTEL SUNSET
    let colors: [Color] = [Color1, Color2, Color3, Color4, Color5, Color6, Color7,Color8]
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


