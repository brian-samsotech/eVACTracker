//
//  HttpUtility.swift
//  EVAS
//
//  Created by Brian on 3/16/21.
//

import Foundation
import UIKit
import Alamofire



class WebService
{
    let Manager: Session = {
        let manager = ServerTrustManager(evaluators: ["": DisabledTrustEvaluator()])
       let configuration = URLSessionConfiguration.af.default
    //    configuration.timeoutIntervalForRequest = 120
       return Session(configuration: configuration, serverTrustManager: manager)
    }()

    
    func NetworkCall<T:Decodable>(requestUrl: String,Method:Alamofire.HTTPMethod, requestBody: [String : Any]?, resultType: T.Type, completionHandler:@escaping(_ result: [String : Any]?,_ error:String?)-> Void)
{
          
print(requestBody)
        print(requestUrl)
      
    Manager.request(requestUrl,method:Method, parameters: requestBody,encoding: JSONEncoding.default).responseJSON { responses in
        print(responses)
        let json = responses.value as? [String:Any]

        if json == nil || json?.isEmpty == true
        {
            
            completionHandler(nil,"02")
        }
        else{
           
            let result = json!["Result"] as? Bool
       
            if(result == true)
            {
             
                if let jsonData =  json!["Data"] as?  [String:Any]
                {
                completionHandler(jsonData,nil)
                }
                else{
                    completionHandler(nil,"Data not availble")
                }
             
            }
           
            else{
                if(json!["Message"] as? String != nil)
                {
                completionHandler(nil,json!["Message"] as? String)
                }
                else{
                    completionHandler(nil,"There seems to be an issue with the response from the server. Please try again")
                }
            }
            
        }
      
 
      }
}
    func NetworkCallArray<T:Decodable>(requestUrl: String,Method:Alamofire.HTTPMethod, requestBody: [String : Any]?, resultType: T.Type, completionHandler:@escaping(_ result: [[String : Any]]?,_ error:String?)-> Void)
{
          
print(requestBody)
        print(requestUrl)
      
    Manager.request(requestUrl,method:Method, parameters: requestBody,encoding: JSONEncoding.default).responseJSON { responses in
        print(responses)
        let json = responses.value as? [String:Any]

        if json == nil || json?.isEmpty == true
        {
            
            completionHandler(nil,"02")
        }
        else{
           
            let result = json!["Result"] as? Bool
       
            if(result == true)
            {
             
                if let jsonData =  json!["Data"] as?  [[String:Any]]
                {
                completionHandler(jsonData,nil)
                }
                else{
                    completionHandler(nil,"Data not availble")
                }
             
            }
           
            else{
                if(json!["Message"] as? String != nil)
                {
                completionHandler(nil,json!["Message"] as? String)
                }
                else{
                    completionHandler(nil,"There seems to be an issue with the response from the server. Please try again")
                }
            }
            
        }
      
 
      }
}
    func NetworkCallValidation<T:Decodable>(requestUrl: String,Method:Alamofire.HTTPMethod, requestBody: [String : Any]?, resultType: T.Type, completionHandler:@escaping(_ result: String?,_ error:String?)-> Void)
{
       

    Manager.request(requestUrl,method:Method, parameters: requestBody,encoding: JSONEncoding.default).responseJSON { responses in

        let json = responses.value as? [String:Any]

        if json == nil || json?.isEmpty == true
        {
            
            completionHandler(nil,"02")
        }
        else{
           
            let result = json!["Result"] as? Bool
       
            if(result == true)
            {
             
                completionHandler("Sucess",nil)
             
            }
           
            else{
                if(json!["Message"] as? String != nil)
                {
                completionHandler(nil,json!["Message"] as? String)
                }
                else{
                    completionHandler(nil,"There seems to be an issue with the response from the server. Please try again")
                }
            }
            
        }
      
 
      }
}

   



}
func convertBase64StringToImage (imageBase64String:String) -> UIImage {
    let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
    var image = UIImage(named: "profilePic")
    if(imageData != nil)
    {
     image = UIImage(data: imageData!) ?? UIImage(named: "profilePic")
      
    }
    return image!
}
func convertImageToBase64String (img: UIImage) -> String {
    return img.jpegData(compressionQuality: 0.01)?.base64EncodedString() ?? ""
}
