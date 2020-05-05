import UIKit

public extension UIImage {
    func convertImageToBase64() -> String? {
        guard let imageData = jpegData(compressionQuality: 0.2) else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
