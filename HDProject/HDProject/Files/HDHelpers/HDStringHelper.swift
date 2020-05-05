import UIKit

public enum Language: String {
    case en = "en"
    case vn = "vn"
}

public struct HDStringHelper {
    public static var language: Language = .en
    
    public static var done: String {
        return language == .en ? "Done" : "Xong"
    }
    
    public static var yes: String {
        return language == .en ? "Yes" : "Có"
    }
    
    public static var no: String {
        return language == .en ? "No" : "Không"
    }
    
    public static var dismiss: String {
        return language == .en ? "Dismiss" : "Đóng"
    }
    
    public static var error: String {
        return language == .en ? "Error" : "Lỗi"
    }
    
    public static var success: String {
        return language == .en ? "Success" : "Thành công"
    }
    
    public static var settings: String {
        return language == .en ? "Settings" : "Cài đặt"
    }
    
    public static var faceIdAndTouchId: String {
        return language == .en ? "Face ID / Touch ID" : "Face ID / Touch ID"
    }
    
    public static var cannotEvaluatePolicyMessage: String {
        return language == .en ? "Face ID / Touch ID not available" : "Face ID / Touch ID không khả dụng"
    }
    
    public static var setup: String {
        return language == .en ? "Setup" : "Thiết lập"
    }
    
    public static var confirm: String {
        return language == .en ? "Confirm" : "Xác nhận"
    }
    
    public static var currentPasscode: String {
        return language == .en ? "Current passcode" : "Mật khẩu hiện tại"
    }
    
    public static var restoredIAP: String {
        return language == .en ? "You've successfully restored your purchase!" : "Bạn đã khôi phục thành công giao dịch mua trong ứng dụng của mình!"
    }
    
    public static var cancel: String {
        return language == .en ? "Cancel" : "Huỷ bỏ"
    }
    
    public static var goToAppStore: String {
        return language == .en ? "Go to app store" : "Đi đến cửa hàng ứng dụng"
    }
    
    public static var forceUpdate: String {
        return language == .en ? "Please go to app store and update new version. Thank you very much" : "Vui lòng đến cửa hàng ứng dụng và cập nhật phiên bản mới. Cảm ơn nhiều"
    }
    
    public static var showAds: String {
        return language == .en ? "If you removed ads. Please follow these steps: \"Settings > Restore Your Purchase\"" : "Nếu bạn đã xoá quảng cáo. Vui lòng làm theo các bước: \"Cài đặt > Khôi phục mua hàng \""
    }
    
    public static var donation: String {
        return language == .en ? "Thank you for your generous donation" : "Cám ơn vì sự quyên góp hào phóng của bạn"
    }
}
