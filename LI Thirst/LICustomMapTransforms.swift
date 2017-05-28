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
  
  class func stringToFloatTransform() -> TransformOf<Float, String> {
    let transform = {
      TransformOf<Float, String>(fromJSON: {
        (value: String?) -> Float? in
        
        return Float(value!)
      }, toJSON: {
        (value: Float?) -> String? in
        
        if let value = value {
          return String(value)
        }
        return nil
      })
    }
    
    return transform()
  }
  
  class func jsonDealarrayToLIDealTransform() -> TransformOf<Array<LIDeal>, Array<Any>> {
    let transform = {
      TransformOf<Array<LIDeal>, Array<Any>>(fromJSON: {
        (jsonArray: Array<Any>?) -> Array<LIDeal>? in
        var finalArray : Array<LIDeal> = []
        
        for jsonDeal in jsonArray! {
          let deal = Mapper<LIDeal>().map(JSONObject: jsonDeal)
          finalArray.append(deal!)
        }
        
        return finalArray
      }, toJSON: {
        (value: Array<LIDeal>?) -> Array<Any>? in
        //This method has no need atm to reverse the object to a dictionary
        return nil
      })
    }

    return transform()
  }
  
  class func jsonDayArrayToLIDayTransform() -> TransformOf<Array<LIDay>, Array<Any>> {
    let transform = {
      TransformOf<Array<LIDay>, Array<Any>>(fromJSON: {
        (jsonArray: Array<Any>?) -> Array<LIDay>? in
        var finalArray : Array<LIDay> = []
        
        for jsonDay in jsonArray! {
          let day = Mapper<LIDay>().map(JSONObject: jsonDay)
          finalArray.append(day!)
        }
        
        return finalArray
      }, toJSON: {
        (value: Array<LIDay>?) -> Array<Any>? in
        //This method has no need atm to reverse the object to a dictionary
        return nil
      })
    }
    
    return transform()
  }

}

