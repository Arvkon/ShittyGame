import UIKit
import Cartography
import SwiftColor

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("91ccec")
        
        dieSideImageView.addSubview(emojiButton)
        view.addSubview(dieSideImageView)
        view.addSubview(coverView)
        
        constrain(emojiButton, dieSideImageView, coverView) { emojiButton, dieSideImageView, coverView in
            emojiButton.centerX == emojiButton.superview!.centerX
            emojiButton.centerY == emojiButton.superview!.centerY
            
            dieSideImageView.centerX == dieSideImageView.superview!.centerX
            dieSideImageView.centerY == dieSideImageView.superview!.centerY
            
            coverView.left   == coverView.superview!.left
            coverView.right  == coverView.superview!.right
            coverView.height == coverView.superview!.height
        }
        
        constrain(coverView, replace: coverViewTopConstraint) { coverView in
            coverView.top == coverView.superview!.bottom
        }
    }
    
    // MARK: - Views
    
    lazy var dieSideImageView: UIImageView = {
        let dieSideImageView = UIImageView(image: UIImage(named: "DieSide"))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: .tapDetected)
        dieSideImageView.addGestureRecognizer(tapRecognizer)
        dieSideImageView.userInteractionEnabled = true
        
        return dieSideImageView
    }()
    
    lazy var emojiButton: UIButton = {
        let emojiButton = UIButton(frame: .zero)
        emojiButton.tintColor = UIColor("bbbbc8")
        emojiButton.setImage(self.currentEmoji.image, forState: .Normal)
        emojiButton.setImage(self.currentEmoji.image, forState: .Highlighted)
        emojiButton.addTarget(self, action: .tapDetected, forControlEvents: .TouchDown)
        
        return emojiButton
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView(frame: .zero)
        coverView.backgroundColor = UIColor.brownColor()
        
        return coverView
    }()
    
    // MARK: - Properties
    
    var currentEmoji = Emoji.Poop
    
    let coverViewTopConstraint = ConstraintGroup()
    
    var coverViewBottomOffset: CGFloat = 0.0
    
    // MARK: - Methods
    
    func tapDetected() {
        coverViewBottomOffset += view.bounds.height / 15
        constrain(coverView, replace: coverViewTopConstraint) { coverView in
            coverView.top == coverView.superview!.bottom - coverViewBottomOffset
        }
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension Selector {
    static let tapDetected = #selector(ViewController.tapDetected)
}
