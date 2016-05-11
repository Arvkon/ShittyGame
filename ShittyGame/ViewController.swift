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
        
        view.layoutIfNeeded()
        
        coverView.addSubview(hashtagLabel)
        
        constrain(hashtagLabel) { hashtagLabel in
            let dieSideImageViewTop = dieSideImageView.frame.origin.y
            hashtagLabel.centerX == hashtagLabel.superview!.centerX
            hashtagLabel.bottom  == hashtagLabel.superview!.bottom - dieSideImageViewTop
        }
        
        setupSound()
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
    
    lazy var hashtagLabel: UILabel = {
        let hashtagLabel = UILabel(frame: .zero)
        hashtagLabel.font = UIFont.systemFontOfSize(17.0)
        hashtagLabel.text = "#shittygamescore"
        hashtagLabel.textColor = UIColor("ffdc00")
        
        return hashtagLabel
    }()
    
    // MARK: - Properties
    
    var currentScore: Int = 0
    
    var currentEmoji = Emoji.Poop
    
    let coverViewTopConstraint = ConstraintGroup()
    
    var coverViewBottomOffset: CGFloat = 0.0
    
    let pointsLabelFont = UIFont.systemFontOfSize(34.0, weight: UIFontWeightMedium)
    
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
    
    func playSound(sound: Sound) {
        // Play sound on background queue to prevent lag
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            do {
                let audioPlayer = try AVAudioPlayer(data: self.soundData[sound]!, fileTypeHint: AVFileTypeWAVE)
                audioPlayer.delegate = self
                self.audioPlayers.append(audioPlayer)
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
            setUserInteractionEnabled(false)
            playSound(Sound.randomEvilLaugh())
        } else {
            currentScore += currentEmoji.points
            animatePointsLabelFor(currentEmoji)
            playSound(.KaChing)
        }
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
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.35))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.updateScoreLabel()
        }
    }
}

extension ViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if let index = audioPlayers.indexOf(player) {
            audioPlayers.removeAtIndex(index)
            if audioPlayers.isEmpty {
                changeEmoji()
                startTimer()
                setUserInteractionEnabled(true)
            }
        }
    }
}

private extension Selector {
    static let changeEmoji = #selector(ViewController.changeEmoji)
    static let tapDetected = #selector(ViewController.tapDetected)
}
