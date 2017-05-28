import Foundation

extension Date {
  func localizedDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
    dateFormatter.timeZone = TimeZone.current
    let localDate = dateFormatter.string(from: Date())
    
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    return dateFormatter.date(from: localDate)!
  }
  
  func dateAdjustedToCurrentDay(date : Date) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss +SSSS"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")

    let stringOfTime = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "yyyy-MM-dd "
    let stringOfDate = dateFormatter.string(from: localizedDate())
    
    
    let fullDate = stringOfDate + stringOfTime
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
    
    return dateFormatter.date(from: fullDate)
  }
  
  func dayOfWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self).capitalized
  }
}
