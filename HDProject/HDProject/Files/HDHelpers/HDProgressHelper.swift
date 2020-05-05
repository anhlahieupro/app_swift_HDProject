import SVProgressHUD

public struct HDProgressHelper { }

public extension HDProgressHelper {
    static func showLoading(timeout: TimeInterval = 60) {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        guard timeout > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { hideLoading() }
    }
    
    static func hideLoading() {
        SVProgressHUD.dismiss()
    }
}
