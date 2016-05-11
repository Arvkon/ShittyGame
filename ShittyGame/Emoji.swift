import UIKit

enum Emoji {
    case Bathtub
    case Bee
    case Cat
    case Diamond
    case Donut
    case Fistbump
    case Goat
    case Invader
    case Kiss
    case Mushroom
    case Poop
    case Rocket
    case Sleep
    case Star
    case Tea
    case TopHat
    
    static let allValues = [Bathtub, Bee, Cat, Diamond, Donut, Fistbump, Goat, Invader, Kiss, Mushroom, Poop, Rocket, Sleep, Star, Tea, TopHat]
    
    static func random() -> Emoji {
        let count = UInt32(Emoji.allValues.count)
        let index = Int(arc4random_uniform(count))
        return Emoji.allValues[index]
    }
    
    var points: Int {
        switch self {
        case .Diamond, .TopHat:
            return 200
        case .Bathtub, .Bee, .Sleep:
            return 150
        case .Fistbump, .Goat, .Mushroom, .Tea:
            return 100
        case .Cat, .Donut, .Invader, .Kiss, .Rocket, .Star:
            return 50
        case .Poop:
            return 0
        }
    }
    
    var imageName: String {
        switch self {
        case .Bathtub:  return "BathtubEmoji"
        case .Bee:      return "BeeEmoji"
        case .Cat:      return "CatEmoji"
        case .Diamond:  return "DiamondEmoji"
        case .Donut:    return "DonutEmoji"
        case .Fistbump: return "FistbumpEmoji"
        case .Goat:     return "GoatEmoji"
        case .Invader:  return "InvaderEmoji"
        case .Kiss:     return "KissEmoji"
        case .Mushroom: return "MushroomEmoji"
        case .Poop:     return "PoopEmoji"
        case .Rocket:   return "RocketEmoji"
        case .Sleep:    return "SleepEmoji"
        case .Star:     return "StarEmoji"
        case .Tea:      return "TeaEmoji"
        case .TopHat:   return "TopHatEmoji"
        }
    }
    
    var image: UIImage {
        return UIImage(named: imageName)!
    }
    
    var templateImage: UIImage {
        return image.imageWithRenderingMode(.AlwaysTemplate)
    }
}
