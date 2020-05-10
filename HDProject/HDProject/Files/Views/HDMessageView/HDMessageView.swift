import UIKit

public class HDMessageView: HDDialogView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    public typealias MessageCompletion = (_ isConfirm: Bool) -> ()
    public var completion: MessageCompletion = { (_) in }
    
    public var isAutoDismiss = true
    public static var isUseSystem = false
    
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
    func show(from viewController: UIViewController?) {
        let viewController = viewController ?? UIApplication.shared.getTopViewController()
        
        if !HDMessageView.isUseSystem {
            show()
        } else {
            let alertController = UIAlertController(title: nil,
                                                    message: messageLabel.text,
                                                    preferredStyle: .alert)
            
            if let yesTitle = yesButton.titleLabel?.text, !yesTitle.isEmpty {
                let yesAction: (UIAlertAction) -> () = { [weak self] _ in
                    guard let self = self else { return }
                    self.yesAction(self.yesButton as Any)
                }
                let yesAlertAction = UIAlertAction(title: yesTitle,
                                                   style: .default,
                                                   handler: yesAction)
                alertController.addAction(yesAlertAction)
            }
            
            let noAction: (UIAlertAction) -> () = { [weak self] _ in
                guard let self = self else { return }
                self.noAction(self.noButton as Any)
            }
            let noTitle = noButton.titleLabel?.text ?? HDStringHelper.dismiss
            let noAlertAction = UIAlertAction(title: noTitle,
                                              style: .default,
                                              handler: noAction)
            alertController.addAction(noAlertAction)
            
            viewController?.present(alertController,
                                    animated: true,
                                    completion: nil)
        }
    }
    
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
