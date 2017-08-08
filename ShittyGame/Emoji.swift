import UIKit

enum Emoji {
    case 🛀 // U+1F6C0
    case 🐝 // U+1F41D
    case 😸 // U+1F638
    case 🍀 // U+1F340
    case 💎 // U+1F48E
    case 🕊️ // U+1F54A
    case 👊 // U+1F44A
    case 👾 // U+1F47E
    case 🕹️ // U+1F579
    case 💋 // U+1F48B
    case 💩 // U+1F4A9
    case 🚀 // U+1F680
    case 🎅🏻 // U+1F3FB
    case 🖖 // U+1F596
    case 🍵 // U+1F375
    case 🎩 // U+1F3A9
    case 🦄 // U+1F984
    case 💡 // U+1F4A1
    case 🤓 // U+1F913
    
    static let allValues = [🛀, 🐝, 😸, 🍀, 💎, 🕊️, 👊, 👾, 🕹️, 💋, 💡, 🤓, 💩, 🚀, 🎅🏻, 🖖, 🍵, 🎩, 🦄]
    
    static func random() -> Emoji {
        let count = UInt32(Emoji.allValues.count)
        let index = Int(arc4random_uniform(count))
        return Emoji.allValues[index]
    }
    
    var points: Int {
        switch self {
        case .💎, .🎩, .🦄:
            return 200
        case .🛀, .🐝, .🍀, .🕊️:
            return 150
        case .👊, .💋, .🤓, .🎅🏻, .🍵:
            return 100
        case .😸, .👾, .🕹️, .💡, .🚀, .🖖:
            return 50
        case .💩:
            return 0
        }
    }
    
    var imageName: String {
        switch self {
        case .🛀: return "BathtubEmoji"
        case .🐝: return "BeeEmoji"
        case .😸: return "CatEmoji"
        case .🍀: return "CloverEmoji"
        case .💎: return "DiamondEmoji"
        case .🕊️: return "DoveEmoji"
        case .👊: return "FistbumpEmoji"
        case .👾: return "InvaderEmoji"
        case .🕹️: return "JoystickEmoji"
        case .💋: return "KissEmoji"
        case .💡: return "LightBulbEmoji"
        case .🤓: return "NerdEmoji"
        case .💩: return "PoopEmoji"
        case .🚀: return "RocketEmoji"
        case .🎅🏻: return "SantaEmoji"
        case .🖖: return "SpockEmoji"
        case .🍵: return "TeaEmoji"
        case .🎩: return "TopHatEmoji"
        case .🦄: return "UnicornEmoji"
        }
    }
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var templateImage: UIImage {
        return image.withRenderingMode(.alwaysTemplate)
    }
}
