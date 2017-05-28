import Foundation
import ObjectMapper

class LIISO8601DateTransform: DateFormatterTransform {
  
  public init() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    super.init(dateFormatter: formatter)
  }
}

class LIDateNoTimeTransform: DateFormatterTransform {
  
  public init() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    
    super.init(dateFormatter: formatter)
  }
}

class LIDateTimeTransform: DateFormatterTransform {
  
  public init() {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "hh:mm a"
    
    super.init(dateFormatter: formatter)
  }
}
