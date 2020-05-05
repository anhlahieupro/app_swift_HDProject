import UIKit

public class HDToolBar: UIToolbar {
    init(actionBarButtonItems: UIBarButtonItem...) {
        super.init(frame: .zero)
        self.items = actionBarButtonItems
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
