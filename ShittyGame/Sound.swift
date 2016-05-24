import Foundation

enum Sound: String {
    case Appearance = "Appearance"
    case EvilLaugh1 = "EvilLaugh1"
    case EvilLaugh2 = "EvilLaugh2"
    case EvilLaugh3 = "EvilLaugh3"
    case EvilLaugh4 = "EvilLaugh4"
    case EvilLaugh5 = "EvilLaugh5"
    case EvilLaugh6 = "EvilLaugh6"
    case KaChing = "KaChing"
    
    static let evilLaughs = [EvilLaugh1, EvilLaugh2, EvilLaugh3, EvilLaugh4, EvilLaugh5, EvilLaugh6]
    static let allValues  = [Appearance, KaChing] + evilLaughs
    
    static var indexOfPreviousEvilLaugh = -1
    
    static func randomEvilLaugh() -> Sound {
        let count = UInt32(Sound.evilLaughs.count)
        var index = Int(arc4random_uniform(count))
        while index == indexOfPreviousEvilLaugh {
            index = Int(arc4random_uniform(count))
        }
        indexOfPreviousEvilLaugh = index
        return Sound.evilLaughs[index]
    }
    
    var isEvilLaugh: Bool {
        return Sound.evilLaughs.contains(self)
    }
}
