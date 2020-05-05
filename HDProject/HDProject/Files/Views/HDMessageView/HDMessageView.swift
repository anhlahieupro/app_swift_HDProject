import UIKit

public class HDMessageView: HDDialogView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    public typealias MessageCompletion = (_ isConfirm: Bool) -> ()
    public var isAutoDismiss = true
    public var completion: MessageCompletion = { (_) in }
    
    public init(message: String,
                noTitle: String = HDStringHelper.dismiss,
                completion: @escaping MessageCompletion) {
        super.init()
        self.completion = completion
        setupViews(message: message, yesTitle: "", noTitle: noTitle)
        yesButton.isHidden = true
    }
    
    public init(confirmMessage message: String,
                yesTitle: String = HDStringHelper.yes,
                noTitle: String = HDStringHelper.no,
                completion: @escaping MessageCompletion) {
        super.init()
        self.completion = completion
        setupViews(message: message, yesTitle: yesTitle, noTitle: noTitle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func yesAction(_ sender: Any) {
        completion(true)
        if isAutoDismiss { dismiss() }
    }
    
    @IBAction func noAction(_ sender: Any) {
        completion(false)
        if isAutoDismiss { dismiss() }
    }
}

public extension HDMessageView {
    private func setupViews(message: String, yesTitle: String, noTitle: String) {
        messageLabel.text = message
        yesButton.setTitle(yesTitle, for: .normal)
        noButton.setTitle(noTitle, for: .normal)
    }
    
    override func setupViews() {
        super.setupViews()
        contentView.clipsToBounds = true
        contentView.setCornersRadius(corners: .allCorners, radius: 5)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false
    }
}
