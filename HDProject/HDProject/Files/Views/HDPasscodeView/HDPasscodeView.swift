import UIKit
import LocalAuthentication

// MARK: - Add NSFaceIDUsageDescription String to Info.plist

public enum HDPasscodeViewMode {
    case setup, confirm, check, change
}

public class HDPasscodeView: HDDialogView {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var input1View: UIView!
    @IBOutlet weak var input2View: UIView!
    @IBOutlet weak var input3View: UIView!
    @IBOutlet weak var input4View: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var faceIdAndTouchIdButton: UIButton!
    
    public  static let savedPasscodeKey = "savedPasscodeKey"
    private static let service          = "HDServicePasscode"
    private static let account          = "HDAccountPasscode"
    
    public var correct: () -> () = { }
    public var dismissClosure: () -> () = { }
    public var confirmPasscode = "" // require if confirm mode
    
    private var isNeedResetInputView = false
    private var mode = HDPasscodeViewMode.setup
    private let faceIdAndTouchIdTitle = HDStringHelper.faceIdAndTouchId
    private let cannotEvaluatePolicyMessage = HDStringHelper.cannotEvaluatePolicyMessage
    private let setupTitle = HDStringHelper.setup
    private let confirmTitle = HDStringHelper.confirm
    private let changeTitle = HDStringHelper.currentPasscode
    
    public init(mode: HDPasscodeViewMode) {
        super.init()
        self.mode = mode
        dismissButton.setTitle(HDStringHelper.cancel, for: .normal)
        switch mode {
        case .setup:
            titleLabel.isHidden = false
            dismissButton.isHidden = false
            faceIdAndTouchIdButton.isHidden = true
            titleLabel.text = setupTitle
        case .confirm:
            titleLabel.isHidden = false
            dismissButton.isHidden = false
            faceIdAndTouchIdButton.isHidden = true
            titleLabel.text = confirmTitle
        case .check:
            titleLabel.isHidden = true
            dismissButton.isHidden = true
            faceIdAndTouchIdButton.isHidden = false
            faceIdAndTouchIdButton.setTitle(faceIdAndTouchIdTitle, for: .normal)
        case .change:
            titleLabel.isHidden = false
            dismissButton.isHidden = false
            faceIdAndTouchIdButton.isHidden = true
            titleLabel.text = changeTitle
        }
        handleViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func show() {
        super.show()
        inputTextField.becomeFirstResponder()
    }
    
    override public func dismiss() {
        inputTextField.resignFirstResponder()
        super.dismiss()
    }
    
    @IBAction func useFaceIdOrTouchIdButtonAction(_ sender: Any) {
        inputTextField.text = ""
        setupBorderParentInputViews(0)
        setupDefaultInputViews(color: .lightGray)
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            inputTextField.resignFirstResponder()
            let messageView = HDMessageView(message: cannotEvaluatePolicyMessage) { [weak self] (_) in
                self?.inputTextField.becomeFirstResponder()
            }
            messageView.show()
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: faceIdAndTouchIdTitle) {
            [weak self] success, authenticationError in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setupDefaultInputViews(color: .darkGray)
                self.correct()
                self.dismiss()
            }
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        if mode == .confirm {
            dismissClosure()
        }
        dismiss()
    }
    
    @IBAction func showKeyboardButtonAction(_ sender: Any) {
        inputTextField.becomeFirstResponder()
    }
}

public extension HDPasscodeView {
    private func handleViews() {
        setupParentInputViews()
        setupInputViews()
    }
    
    private func setupParentInputViews() {
        input1View.superview?.cornerRadius = 5
        input2View.superview?.cornerRadius = 5
        input3View.superview?.cornerRadius = 5
        input4View.superview?.cornerRadius = 5
        
        input1View.superview?.borderColor = .red
        input2View.superview?.borderColor = .red
        input3View.superview?.borderColor = .red
        input4View.superview?.borderColor = .red
        
        setupBorderParentInputViews(0)
    }
    
    private func setupBorderParentInputViews(_ border: CGFloat) {
        input1View.superview?.borderWidth = border
        input2View.superview?.borderWidth = border
        input3View.superview?.borderWidth = border
        input4View.superview?.borderWidth = border
    }
    
    private func setupInputViews() {
        input1View.cornerRadius = input1View.frame.height / 2
        input2View.cornerRadius = input1View.frame.height / 2
        input3View.cornerRadius = input1View.frame.height / 2
        input4View.cornerRadius = input1View.frame.height / 2
        
        setupDefaultInputViews(color: .lightGray)
    }
    
    private func setupDefaultInputViews(color: UIColor) {
        input1View.backgroundColor = color
        input2View.backgroundColor = color
        input3View.backgroundColor = color
        input4View.backgroundColor = color
    }
    
    private func incorrect() {
        isNeedResetInputView = true
        inputTextField.text = ""
        setupDefaultInputViews(color: .lightGray)
        setupBorderParentInputViews(1)
        shake()
    }
    
    private func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: stackView.center.x - 10, y: stackView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: stackView.center.x + 10, y: stackView.center.y))
        
        stackView.layer.add(animation, forKey: "position")
    }
    
    private func setupMode() {
        let passcode = inputTextField.text ?? ""
        let passcodeView = HDPasscodeView(mode: .confirm)
        passcodeView.confirmPasscode = passcode
        inputTextField.text = ""
        passcodeView.correct = { [weak self] in
            self?.dismiss()
        }
        passcodeView.dismissClosure = { [weak self] in
            self?.inputTextField.becomeFirstResponder()
        }
        passcodeView.show()
    }
    
    private func confirmMode() {
        let passcode = inputTextField.text ?? ""
        if passcode == confirmPasscode {
            HDKeychain.savePassword(service: HDPasscodeView.service,
                                    account: HDPasscodeView.account,
                                    data: passcode)
            let savedPasscodeKey = Notification.Name(rawValue: HDPasscodeView.savedPasscodeKey)
            NotificationCenter.default.post(name: savedPasscodeKey, object: nil, userInfo: nil)
            correct()
            dismiss()
        } else {
            incorrect()
        }
    }
    
    private func checkMode()  {
        if inputTextField.text == HDPasscodeView.getCurrentPasscode() {
            correct()
            dismiss()
        } else {
            incorrect()
        }
    }
    
    private func changeMode() {
        if inputTextField.text == HDPasscodeView.getCurrentPasscode() {
            let passcodeView = HDPasscodeView(mode: .setup)
            passcodeView.show()
            dismiss()
        } else {
            incorrect()
        }
    }
}

public extension HDPasscodeView {
    static func showIfNeeded(isHiddenFaceIdAndTouchId: Bool = false) {
        guard !HDPasscodeView.getCurrentPasscode().isEmpty, let window = HDAppDelegateHelper.window else { return }
        for subview in window.subviews where subview is HDPasscodeView {
            guard let passcodeView = subview as? HDPasscodeView else { return }
            if passcodeView.mode == .check { return }
        }
        let passcodeView = HDPasscodeView(mode: .check)
        passcodeView.faceIdAndTouchIdButton.isHidden = isHiddenFaceIdAndTouchId
        passcodeView.show()
    }
    
    static func getCurrentPasscode() -> String {
        return HDKeychain.getPassword(service: HDPasscodeView.service, account: HDPasscodeView.account) ?? ""
    }
    
    static func removeCurrentPasscode() {
        HDKeychain.removePassword(service: HDPasscodeView.service, account: HDPasscodeView.account)
    }
}

extension HDPasscodeView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = (textField.text?.count ?? 0)
        
        if string.isEmpty {
            switch count {
            case 1:
                input1View.backgroundColor = .lightGray
                return true
            case 2:
                input2View.backgroundColor = .lightGray
                return true
            case 3:
                input3View.backgroundColor = .lightGray
                return true
            case 4:
                input4View.backgroundColor = .lightGray
                return true
            default:
                return false
            }
        } else {
            if isNeedResetInputView {
                isNeedResetInputView = false
                setupBorderParentInputViews(0)
                setupDefaultInputViews(color: .lightGray)
            }
            
            switch count {
            case 0:
                input1View.backgroundColor = .darkGray
                return true
            case 1:
                input2View.backgroundColor = .darkGray
                return true
            case 2:
                input3View.backgroundColor = .darkGray
                return true
            case 3:
                input4View.backgroundColor = .darkGray
                let passcode = (textField.text ?? "") + string
                textField.text = passcode
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
                    guard let self = self else { return }
                    switch self.mode {
                    case .setup:    self.setupMode()
                    case .confirm:  self.confirmMode()
                    case .check:    self.checkMode()
                    case .change:   self.changeMode()
                    }
                }
                return false
            default:
                return false
            }
        }
    }
}

public extension HDPasscodeView {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false
    }
}
