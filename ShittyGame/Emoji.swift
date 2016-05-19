import UIKit

enum Emoji {
    case 🛀 // U+1F6C0
    case 🐝 // U+1F41D
    case 😸 // U+1F638
    case 💎 // U+1F48E
    case 🍩 // U+1F369
    case 👊 // U+1F44A
    case 🐐 // U+1F410
    case 👾 // U+1F47E
    case 💋 // U+1F48B
    case 🍄 // U+1F344
    case 💩 // U+1F4A9
    case 🚀 // U+1F680
    case 😴 // U+1F634
    case 🌟 // U+2B50
    case 🍵 // U+1F375
    case 🎩 // U+1F3A9
    
    static let allValues = [🛀, 🐝, 😸, 💎, 🍩, 👊, 🐐, 👾, 💋, 🍄, 💩, 🚀, 😴, 🌟, 🍵, 🎩]
    
    static func random() -> Emoji {
        let count = UInt32(Emoji.allValues.count)
        let index = Int(arc4random_uniform(count))
        return Emoji.allValues[index]
    }
    
    var points: Int {
        switch self {
        case 💎, 🎩:
            return 200
        case 🛀, 🐝, 😴:
            return 150
        case 👊, 🐐, 🍄, 🍵:
            return 100
        case 😸, 🍩, 👾, 💋, 🚀, 🌟:
            return 50
        case 💩:
            return 0
        }
    }
    
    var imageName: String {
        switch self {
        case 🛀: return "BathtubEmoji"
        case 🐝: return "BeeEmoji"
        case 😸: return "CatEmoji"
        case 💎: return "DiamondEmoji"
        case 🍩: return "DonutEmoji"
        case 👊: return "FistbumpEmoji"
        case 🐐: return "GoatEmoji"
        case 👾: return "InvaderEmoji"
        case 💋: return "KissEmoji"
        case 🍄: return "MushroomEmoji"
        case 💩: return "PoopEmoji"
        case 🚀: return "RocketEmoji"
        case 😴: return "SleepEmoji"
        case 🌟: return "StarEmoji"
        case 🍵: return "TeaEmoji"
        case 🎩: return "TopHatEmoji"
        }
    }
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var templateImage: UIImage {
        return image.imageWithRenderingMode(.AlwaysTemplate)
    }
}
