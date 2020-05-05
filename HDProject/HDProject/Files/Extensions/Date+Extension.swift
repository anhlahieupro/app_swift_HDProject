import UIKit

public enum DateFormatStyle: String {
    case EEEEMMMdyyyy     = "EEEE, MMM d, yyyy"//    Wednesday, Sep 12, 2018
    case MMddyyyy         = "MM/dd/yyyy"//    09/12/2018
    case MMddyyyyHHmm     = "MM-dd-yyyy HH:mm"//    09-12-2018 14:11
    case MMMdhmma         = "MMM d, h:mm a"//    Sep 12, 2:11 PM
    case MMMMyyyy         = "MMMM yyyy"//    September 2018
    case MMMdyyyy         = "MMM d, yyyy"//    Sep 12, 2018
    case EdMMMyyyyHHmmssZ = "E, d MMM yyyy HH:mm:ss Z"//    Wed, 12 Sep 2018 14:11:54 +0000
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"//    2018-09-12T14:11:54+0000
    case ddMMyy           = "dd.MM.yy"//    12.09.18
    case HHmmssSSS        = "HH:mm:ss.SSS"//    10:41:02.112
    case hmma             = "h:mm a"//    10:41 AM
    case MMddyyyyE        = "MM/dd/yyyy (E)"//    09/12/2018 (Wed)
}

public enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

public extension Date {
    static func today() -> Date {
        return Date()
    }
    
    func toString(format: DateFormatStyle = .MMddyyyy) -> String {
        return DateFormatter.getString(format: format, date: self)
    }
    
    func toString(format: String = DateFormatStyle.MMddyyyy.rawValue) -> String {
        return DateFormatter.getString(format: format, date: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    func daysBetween(to date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: date).day ?? 0
    }
}

// get hour, minute, second
public extension Date {
    var hour: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.hour ?? 0
    }
    
    var minute: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.minute ?? 0
    }
    
    var second: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.second ?? 0
    }
    
    var day: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.day ?? 0
    }
    
    var month: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.month ?? 0
    }
    
    var year: Int {
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let calendar = Calendar.current
        let components = calendar.dateComponents(component, from: self)
        return components.year ?? 0
    }
}

// next, previous day of week
public extension Date {
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)
        if considerToday && calendar.component(.weekday, from: self) == weekday.rawValue {
            return self
        }
        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime, direction: .forward)!
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(weekday: weekday.rawValue)
        if considerToday && calendar.component(.weekday, from: self) == weekday.rawValue {
            return self
        }
        return calendar.nextDate(after: self, matching: components, matchingPolicy: .nextTime, direction: .backward)!
    }
}

// add year, month, day, hour, minute, second
public extension Date {
    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    
    func adding(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: weeks * 7, to: self)!
    }
    
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}

public extension Date {
    func set(year: Int? = nil,
             month: Int? = nil,
             day: Int? = nil,
             hour: Int? = nil,
             minute: Int? = nil,
             second: Int? = nil) -> Date {
        let calendar = Calendar.current
        let component: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var dateComponents: DateComponents? = calendar.dateComponents(component, from: self)
        dateComponents?.year   = year   ?? self.year
        dateComponents?.month  = month  ?? self.month
        dateComponents?.day    = day    ?? self.day
        dateComponents?.hour   = hour   ?? self.hour
        dateComponents?.minute = minute ?? self.minute
        dateComponents?.second = second ?? self.second
        return calendar.date(from: dateComponents!) ?? self
    }
}
