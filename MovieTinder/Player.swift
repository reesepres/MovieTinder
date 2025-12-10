import SwiftUI

private let pink = Color(red: 225/225, green: 192/255, blue: 203/225)
// testing Github Subscription to Slack
struct Player: Identifiable {
    let id: Int
    let color: Color
}

func makePlayers(count: Int) -> [Player] {
    let Color1 = Color(hex: "C2F0FF") //Light Blue
    let Color2 = Color(hex: "A1E4FF") //BLUE  89D1FF
    let Color3 = Color(hex: "8AB8E6") //CREAMY PEACH 8AB8E6
    let Color4 = Color(hex: "89D1FF") //DARK PURPLE 4AA6FF
    let Color5 = Color(hex: "4AA6FF") //SEAFOAM MIST
    let Color6 = Color(hex: "5C93C9") //ROSEWATER GLOW 5C93C9
    let Color7 = Color(hex: "3294F2") //LAVENDAR COTTON
    let Color8 = Color(hex: "267BE5") //PASTEL SUNSET
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


