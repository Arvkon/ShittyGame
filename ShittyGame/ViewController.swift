import UIKit
import Cartography
import SwiftColor
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("91ccec")
        
        dieSideImageView.addSubview(emojiButton)
        
        constrain(emojiButton) { emojiButton in
            emojiButton.centerX == emojiButton.superview!.centerX
            emojiButton.centerY == emojiButton.superview!.centerY
        }
        
        view.addSubview(scoreLabel)
        view.addSubview(dieSideImageView)
        view.addSubview(coverView)
        
        constrain(scoreLabel, dieSideImageView, coverView) { scoreLabel, dieSideImageView, coverView in
            scoreLabel.centerX == scoreLabel.superview!.centerX
            scoreLabel.bottom  == dieSideImageView.top - view.bounds.height * 0.09
            
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
    
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel(frame: .zero)
        scoreLabel.font = UIFont.systemFontOfSize(60.0)
        scoreLabel.text = "\(self.currentScore)"
        
        return scoreLabel
    }()
    
    lazy var dieSideImageView: TouchDownImageView = {
        let dieSideImageView = TouchDownImageView(image: UIImage(named: "DieSide"))
        dieSideImageView.touchDownAction = self.tapDetected
        dieSideImageView.userInteractionEnabled = true
        
        return dieSideImageView
    }()
    
    class TouchDownImageView: UIImageView {
        var touchDownAction: (() -> Void)?
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            touchDownAction?()
        }
    }
    
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
    
    var currentScore: Int = 0
    
    var currentEmoji = Emoji.Poop
    
    let coverViewTopConstraint = ConstraintGroup()
    
    var coverViewBottomOffset: CGFloat = 0.0
    
    // MARK: - Timer
    
    var timer: NSTimer?
    
    func startTimer() {
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: .changeEmoji, userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Sound
    
    var audioPlayer: AVAudioPlayer?
    
    func playSound() {
        guard let sound = NSDataAsset(name: "ShittyLaugh1") else {
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
            try audioPlayer = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeWAVE)
            audioPlayer!.play()
        } catch {
            print("Error initializing AVAudioPlayer")
        }
    }
    
    // MARK: - Methods
    
    func changeEmoji() {
        var newEmoji = Emoji.random()
        while newEmoji == currentEmoji {
            newEmoji = Emoji.random()
        }
        emojiButton.setImage(newEmoji.templateImage, forState: .Normal)
        emojiButton.setImage(newEmoji.templateImage, forState: .Highlighted)
        currentEmoji = newEmoji
    }
    
    func tapDetected() {
        if timer == nil {
            changeEmoji()
            startTimer()
            return
        }
        
        stopTimer()
        
        emojiButton.setImage(currentEmoji.image, forState: .Normal)
        emojiButton.setImage(currentEmoji.image, forState: .Highlighted)
        
        if currentEmoji == .Poop {
            coverViewBottomOffset += view.bounds.height / 15
            constrain(coverView, replace: coverViewTopConstraint) { coverView in
                coverView.top == coverView.superview!.bottom - coverViewBottomOffset
            }
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
            // Play sound on background queue to prevent lag
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                self.playSound()
            }
        } else {
            currentScore += currentEmoji.points
            scoreLabel.text = "\(currentScore)"
        }
    }
}

private extension Selector {
    static let changeEmoji = #selector(ViewController.changeEmoji)
    static let tapDetected = #selector(ViewController.tapDetected)
}
