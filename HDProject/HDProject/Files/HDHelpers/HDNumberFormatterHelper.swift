import UIKit

public struct HDNumberFormatterHelper { }

public extension HDNumberFormatterHelper {
    static var maximumFractionDigits = 2
    
    static var numberFormatter: NumberFormatter = {
        let numberFormatter                   = NumberFormatter()
        numberFormatter.numberStyle           = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.decimalSeparator      = getDecimalSeparator()
        numberFormatter.groupingSeparator     = getGroupingSeparator()
        return numberFormatter
    }()
    
    static func getDecimalSeparator() -> String {
        let locale = Locale.current
        return locale.decimalSeparator ?? "."
    }
    
    static func getGroupingSeparator() -> String {
        let decimalSeparator = getDecimalSeparator()
        return (decimalSeparator == "." ? "," : ".")
    }
    
    static func getNumber(string: String) -> Double {
        return numberFormatter.number(from: string)?.doubleValue ?? 0
    }
    
    static func getString(number: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: number)) ?? "0"
    }
}
