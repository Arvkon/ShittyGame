import UIKit
import Cartography
import SwiftColor
import AVFoundation

private let RunIntroSequence = true

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
        view.addSubview(speechBubbleButton)
        view.addSubview(coverView)
        
        constrain(scoreLabel, dieSideImageView, speechBubbleButton) { scoreLabel, dieSideImageView, speechBubbleButton in
            scoreLabel.centerX == scoreLabel.superview!.centerX
            scoreLabel.bottom  == dieSideImageView.top - view.bounds.height * 0.09
            
            dieSideImageView.centerX == dieSideImageView.superview!.centerX
            dieSideImageView.centerY == dieSideImageView.superview!.centerY
            
            speechBubbleButton.left   == speechBubbleButton.superview!.left + 20.0
            speechBubbleButton.right  == speechBubbleButton.superview!.right - 20.0
            speechBubbleButton.height == 90.0
        }
        
        let speechBubbleBottomConstraint = constrain(speechBubbleButton) { speechBubbleButton in
            speechBubbleButton.bottom == speechBubbleButton.superview!.bottom - 70.0
        }
        
        constrain(coverView) { coverView in
            coverView.left   == coverView.superview!.left
            coverView.right  == coverView.superview!.right
            coverView.height == coverView.superview!.height
        }
        
        constrain(coverView, replace: coverViewTopConstraint) { coverView in
            coverView.top == coverView.superview!.bottom
        }
        
        view.layoutIfNeeded()
        
        coverView.addSubview(hashtagLabel)
        
        constrain(hashtagLabel) { hashtagLabel in
            let dieSideImageViewTop = dieSideImageView.frame.origin.y
            hashtagLabel.centerX == hashtagLabel.superview!.centerX
            hashtagLabel.bottom  == hashtagLabel.superview!.bottom - dieSideImageViewTop
        }
        
        setupSound()
        
        // Animations
        
        if RunIntroSequence {
            performAfterSeconds(1.3) {
                UIView.animateWithDuration(0.3) {
                    self.emojiButton.alpha = 1.0
                }
                // Start speech bubbles' downward motion
                constrain(self.speechBubbleButton, replace: speechBubbleBottomConstraint) { speechBubbleButton in
                    speechBubbleButton.bottom == speechBubbleButton.superview!.bottom - 30.0
                }
                UIView.animateWithDuration(1.3) {
                    self.speechBubbleButton.layoutIfNeeded()
                }
            }
            performAfterSeconds(1.9) {
                UIView.animateWithDuration(0.7) {
                    self.speechBubbleButton.alpha = 1.0
                }
            }
            performAfterSeconds(2.8) {
                self.startTextTimer()
            }
        }
    }
    
    // MARK: - Views
    
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel(frame: .zero)
        scoreLabel.font = UIFont.systemFontOfSize(60.0)
        scoreLabel.text = "\(self.currentScore)"
        scoreLabel.alpha = RunIntroSequence ? 0.0 : 1.0
        
        return scoreLabel
    }()
    
    lazy var dieSideImageView: TouchDownImageView = {
        let dieSideImageView = TouchDownImageView(image: UIImage(named: "DieSide"))
        dieSideImageView.touchDownAction = self.tapDetected
        dieSideImageView.userInteractionEnabled = !RunIntroSequence
        
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
        emojiButton.userInteractionEnabled = !RunIntroSequence
        emojiButton.alpha = RunIntroSequence ? 0.0 : 1.0
        
        return emojiButton
    }()
    
    lazy var speechBubbleButton: UIButton = {
        let speechBubbleButton = UIButton(frame: .zero)
        speechBubbleButton.backgroundColor = UIColor("f1deb6")
        speechBubbleButton.layer.borderColor = UIColor("674d3c").CGColor
        speechBubbleButton.layer.borderWidth = 2.0
        speechBubbleButton.layer.cornerRadius = 7.0
        speechBubbleButton.titleLabel!.lineBreakMode = .ByWordWrapping
        speechBubbleButton.addTarget(self, action: .speechBubbleTapped, forControlEvents: .TouchUpInside)
        speechBubbleButton.userInteractionEnabled = false
        speechBubbleButton.alpha = 0.0
        
        return speechBubbleButton
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView(frame: .zero)
        coverView.backgroundColor = UIColor.brownColor()
        
        return coverView
    }()
    
    lazy var hashtagLabel: UILabel = {
        let hashtagLabel = UILabel(frame: .zero)
        hashtagLabel.font = UIFont.systemFontOfSize(17.0)
        hashtagLabel.text = "#shittygamescore"
        hashtagLabel.textColor = UIColor("ffdc00")
        
        return hashtagLabel
    }()
    
    // MARK: - Properties
    
    var currentScore: Int = 0
    
    var currentEmoji = Emoji.💩
    
    let coverViewTopConstraint = ConstraintGroup()
    
    var coverViewBottomOffset: CGFloat = 0.0
    
    let pointsLabelFont = UIFont.systemFontOfSize(34.0, weight: UIFontWeightMedium)
    
    var speechBubbleHasBeenDismissed = false
    
    lazy var speechBubbleAttributedText: NSAttributedString = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 15.0
        paragraphStyle.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: UIFont(name: "PressStart2P", size: 12.0)!,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        
        let text = "Feelin' lucky, punk?\nThen roll the die..."
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        let textColorAttribute = [NSForegroundColorAttributeName: UIColor("d12228")]
        attributedText.addAttributes(textColorAttribute, range: NSRange(location: 26, length: 12))
        
        return attributedText
    }()
    
    var printLength = 0
    
    // MARK: - Timers
    
    var textTimer: NSTimer?
    
    func startTextTimer() {
        textTimer?.invalidate()
        textTimer = NSTimer.scheduledTimerWithTimeInterval(0.06, target: self, selector: .printNext, userInfo: nil, repeats: true)
    }
    
    func stopTextTimer() {
        textTimer?.invalidate()
        textTimer = nil
    }
    
    func printNext() {
        guard printLength < speechBubbleAttributedText.length else {
            stopTextTimer()
            setUserInteractionEnabled(true)
            speechBubbleButton.userInteractionEnabled = true
            return
        }
        
        let string = speechBubbleAttributedText.string
        let substr = string.substringToIndex(string.startIndex.advancedBy(printLength + 1))
        printLength = substr.hasSuffix(" ") ? printLength + 2 : printLength + 1
        
        let range = NSRange(location: 0, length: printLength)
        let title = speechBubbleAttributedText.attributedSubstringFromRange(range)
        speechBubbleButton.setAttributedTitle(title, forState: .Normal)
        
        if printLength == 20 {
            stopTextTimer()
            performAfterSeconds(1.2) {
                self.startTextTimer()
            }
        }
    }
    
    // Emoji randomization timer
    
    var emojiTimer: NSTimer?
    
    func startEmojiTimer() {
        emojiTimer?.invalidate()
        emojiTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: .changeEmoji, userInfo: nil, repeats: true)
    }
    
    func stopEmojiTimer() {
        emojiTimer?.invalidate()
        emojiTimer = nil
    }
    
    // MARK: - Sound
    
    lazy var soundData: [Sound: NSData] = {
        var soundData = [Sound: NSData]()
        for sound in Sound.allValues {
            soundData[sound] = NSDataAsset(name: sound.rawValue)!.data
        }
        
        return soundData
    }()
    
    func setupSound() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        } catch {
            print("Error initializing AVAudioSession")
        }
    }
    
    var audioPlayers = [AVAudioPlayer]()
    var evilLaughPlayer: AVAudioPlayer?
    
    func playSound(sound: Sound) {
        // Play sound on background queue to prevent lag
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let audioPlayer = try AVAudioPlayer(data: self.soundData[sound]!, fileTypeHint: AVFileTypeWAVE)
                audioPlayer.delegate = self
                if sound.isEvilLaugh {
                    self.evilLaughPlayer = audioPlayer
                } else {
                    self.audioPlayers.append(audioPlayer)
                }
                audioPlayer.play()
            } catch {
                print("Error initializing AVAudioPlayer")
            }
        }
    }
    
    // MARK: - Methods
    
    func setUserInteractionEnabled(enabled: Bool) {
        emojiButton.userInteractionEnabled = enabled
        dieSideImageView.userInteractionEnabled = enabled
    }
    
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
        if speechBubbleHasBeenDismissed == false {
            UIView.animateWithDuration(0.35) {
                self.speechBubbleButton.alpha = 0.0
            }
            UIView.animateWithDuration(1.0) {
                self.scoreLabel.alpha = 1.0
            }
            speechBubbleHasBeenDismissed = true
        }
        
        if emojiTimer == nil {
            changeEmoji()
            startEmojiTimer()
            return
        }
        
        stopEmojiTimer()
        
        emojiButton.setImage(currentEmoji.image, forState: .Normal)
        emojiButton.setImage(currentEmoji.image, forState: .Highlighted)
        
        if currentEmoji == .💩 {
            coverViewBottomOffset += view.bounds.height / 15
            constrain(coverView, replace: coverViewTopConstraint) { coverView in
                coverView.top == coverView.superview!.bottom - coverViewBottomOffset
            }
            UIView.animateWithDuration(0.5) {
                self.view.layoutIfNeeded()
            }
            setUserInteractionEnabled(false)
            playSound(Sound.randomEvilLaugh())
        } else {
            currentScore += currentEmoji.points
            animatePointsLabelFor(currentEmoji)
            playSound(.KaChing)
        }
    }
    
    func speechBubbleTapped() {
        UIView.animateWithDuration(0.2, animations: {
            self.dieSideImageView.transform = CGAffineTransformMakeScale(1.08, 1.08)
        }, completion: { _ in
            UIView.animateWithDuration(0.2) {
                self.dieSideImageView.transform = CGAffineTransformIdentity
            }
        })
    }
    
    func updateScoreLabel() {
        UIView.animateWithDuration(0.1, animations: {
            self.scoreLabel.alpha = 0.0
        }, completion: { _ in
            self.scoreLabel.text = "\(self.currentScore)"
            UIView.animateWithDuration(0.2) {
                self.scoreLabel.alpha = 1.0
            }
        })
    }
    
    func animatePointsLabelFor(emoji: Emoji) {
        let pointsLabel = UILabel(frame: .zero)
        pointsLabel.textColor = UIColor("54b649")
        pointsLabel.text = "+\(emoji.points)"
        pointsLabel.font = pointsLabelFont
        view.addSubview(pointsLabel)
        
        constrain(pointsLabel) { pointsLabel in
            pointsLabel.centerX == pointsLabel.superview!.centerX
        }
        let animationConstraint = constrain(pointsLabel) { pointsLabel in
            pointsLabel.centerY == pointsLabel.superview!.centerY - 60.0
        }
        view.layoutIfNeeded()
        
        // Animations
        
        constrain(pointsLabel, scoreLabel, replace: animationConstraint) { pointsLabel, scoreLabel in
            pointsLabel.top == scoreLabel.top
        }
        UIView.animateWithDuration(0.6, animations: {
            self.view.layoutIfNeeded()
            pointsLabel.alpha = 0.0
        }, completion: { _ in
            pointsLabel.removeFromSuperview()
        })
        
        // Trigger score label update separately for better timing
        performAfterSeconds(0.35) {
            self.updateScoreLabel()
        }
    }
    
    func performAfterSeconds(seconds: Double, closure: () -> Void) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
        dispatch_after(delay, dispatch_get_main_queue()) {
            closure()
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if player == evilLaughPlayer {
            changeEmoji()
            startEmojiTimer()
            evilLaughPlayer = nil
            setUserInteractionEnabled(true)
        } else if let index = audioPlayers.indexOf(player) {
            audioPlayers.removeAtIndex(index)
        }
    }
}

private extension Selector {
    static let printNext   = #selector(ViewController.printNext)
    static let changeEmoji = #selector(ViewController.changeEmoji)
    static let tapDetected = #selector(ViewController.tapDetected)
    static let speechBubbleTapped = #selector(ViewController.speechBubbleTapped)
}
