import Foundation
import UIKit

extension UIColor {
  class var li_lightBlueColor: UIColor {
    return UIColor.li_colorWith(red: 100, green: 199, blue: 236, alpha: 1.0)
  }
  
  class func li_colorWith(red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
    return UIColor(colorLiteralRed: Float(Double(red)/255.0),
                   green: Float(Double(green)/255.0),
                   blue: Float(Double(blue)/255.0), alpha: alpha)
  }
}
