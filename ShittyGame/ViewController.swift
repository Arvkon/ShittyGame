import UIKit
import Cartography
import SwiftColor

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("91ccec")
        
        view.addSubview(dieSideImageView)
        view.addSubview(coverView)
        
        constrain(dieSideImageView, coverView) { dieSideImageView, coverView in
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
    
    lazy var coverView: UIView = {
        let coverView = UIView(frame: .zero)
        coverView.backgroundColor = UIColor.brownColor()
        
        return coverView
    }()
    
    // MARK: - Properties
    
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
