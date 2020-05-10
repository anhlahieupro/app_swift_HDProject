import UIKit

public class HDActionButton: UIButton {
    @objc public var buttonActionTouchUpInside: () -> () = { }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    @objc private func touchUp() {
        buttonActionTouchUpInside()
    }
}
