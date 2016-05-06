import UIKit

enum Emoji {
    case Diamond
    case Donut
    case Invader
    case Kiss
    case Poop
    case Star
    case Statue
    case Tea
    
    static let allValues = [Diamond, Donut, Invader, Kiss, Poop, Star, Statue, Tea]
    
    static func random() -> Emoji {
        let count = UInt32(Emoji.allValues.count)
        let index = Int(arc4random_uniform(count))
        return Emoji.allValues[index]
    }
    
    var points: Int {
        switch self {
        case .Diamond:
            return 200
        case .Donut:
            return 100
        case .Invader:
            return 150
        case .Kiss:
            return 50
        case .Poop:
            return 0
        case .Star:
            return 50
        case .Statue:
            return 150
        case .Tea:
            return 100
        }
    }
    
    var imageName: String {
        switch self {
        case .Diamond:
            return "DiamondEmoji"
        case .Donut:
            return "DonutEmoji"
        case .Invader:
            return "InvaderEmoji"
        case .Kiss:
            return "KissEmoji"
        case .Poop:
            return "PoopEmoji"
        case .Star:
            return "StarEmoji"
        case .Statue:
            return "StatueEmoji"
        case .Tea:
            return "TeaEmoji"
        }
    }
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var templateImage: UIImage {
        return image.imageWithRenderingMode(.AlwaysTemplate)
    }
}
