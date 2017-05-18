import Alamofire
import Foundation

class LIAPIRequest {
  static let baseURL: String = "https://lithirst.herokuapp.com"
  static let host: String = "lithirst.herokuapp.com"
  var url : String = ""
  
  func request(methodType:HTTPMethod,
               path: String,
               success: @escaping((_ response: DataResponse<Any>?) -> ()),
               failure: @escaping ((_ error: Error) -> ())) {
    request(methodType: methodType,
            path: path,
            phpFile: "",
            success: success,
            failure: failure)
  }
  
  func request(methodType:HTTPMethod,
               path: String,
               phpFile : String,
               success: @escaping((_ response: DataResponse<Any>?) -> ()),
               failure: @escaping ((_ error: Error) -> ())) {
    if methodType == .get {
      self.url = LIAPIRequest.baseURL + path + phpFile
      Alamofire.request(url).responseJSON { response in
        if let error = response.error {
          failure(error)
        } else {
          success(response)
        }
      }
    }
  }
  
  // MARK: JSON Serializers
  
  public func serializeJSONArray(response: DataResponse<Any>, data: @escaping((Array<Any>) -> ())) {
    do {
      if let jsonResult = try JSONSerialization.jsonObject(with: response.data!,
                                                           options: JSONSerialization.ReadingOptions.mutableContainers) as? Array<Any> {
        data(jsonResult)
      }
    } catch let error as NSError {
      print("Error with \(self.url) Error Description: \(error.localizedDescription)")
    }
  }
  
  public func serializeJSONDictionary(response: DataResponse<Any>, rootkey: String, data: @escaping((Array<Any>) -> ())) {
    do {
      if let jsonResult = try JSONSerialization.jsonObject(with: response.data!,
                                                        options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
          let isError = jsonResult["is_error"] as? Bool
          let errorDescription = jsonResult["error_type"]
          let errorType = jsonResult["error_description"]
          
          if isError == true {
            print("Error with \(self.url)\n Error Type : \(errorType)\n Error Description: \(errorDescription)")
          } else {
            data(jsonResult.object(forKey: rootkey) as! Array<Any>)
          }
        
      }
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
}
