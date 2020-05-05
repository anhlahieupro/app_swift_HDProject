import UIKit

public class HDToast: HDDialogView {
    @IBOutlet weak var messageLabel: UILabel!
    
    public init(message: String) {
        super.init()
        messageLabel.text = message
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func show() {
        super.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.dismiss()
        }
    }
}
