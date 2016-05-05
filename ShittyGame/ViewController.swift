import UIKit
import Cartography
import SwiftColor

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("91ccec")
        
        view.addSubview(dieSideImageView)
        
        constrain(dieSideImageView) { dieSideImageView in
            dieSideImageView.centerX == dieSideImageView.superview!.centerX
            dieSideImageView.centerY == dieSideImageView.superview!.centerY
        }
    }
    
    // MARK: - Views
    
    let dieSideImageView = UIImageView(image: UIImage(named: "DieSide"))
}
