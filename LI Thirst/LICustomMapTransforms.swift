import Foundation
import ObjectMapper

class LICustomMapTransforms {
  
  class func stringToIntTransform() -> TransformOf<Int, String> {
    let transform = {
      TransformOf<Int, String>(fromJSON: {
        (value: String?) -> Int? in
        
        return Int(value!)
      }, toJSON: {
        (value: Int?) -> String? in
        
        if let value = value {
          return String(value)
        }
        return nil
      })
    }
    
    return transform()
  }

  class func stringToDoubleTransform() -> TransformOf<Double, String> {
    let transform = {
      TransformOf<Double, String>(fromJSON: {
        (value: String?) -> Double? in
        
        return Double(value!)
      }, toJSON: {
        (value: Double?) -> String? in
        
        if let value = value {
          return String(value)
        }
        return nil
      })
    }
    
    return transform()
  }

}

