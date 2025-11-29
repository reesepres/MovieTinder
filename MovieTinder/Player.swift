import SwiftUI

private let pink = Color(red: 225/225, green: 192/255, blue: 203/225)
// testing Github Subscription to Slack
struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let Color1 = Color(hex: "E6EFE9")
    let Color2 = Color(hex: "C5F4E0")
    let Color3 = Color(hex: "F7567C")
    let Color4 = Color(hex: "99E1D9")
    let Color5 = Color(hex: "90C2E7")
    
//    let colors: [Color] = [Color1, Color2, Color3, Color4, Color5, Color1, Color2,Color3]
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .teal, pink]
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


