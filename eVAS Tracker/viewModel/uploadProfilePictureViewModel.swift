//
//  uploadProfilePictureViewModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
class uploadProfilePictureViewModel:NSObject
{
    
    var onStartLoading: (() -> Void)?
    var onStopLoading: (() -> Void)?
    var onSuccessHandler: ((Bool) -> Void)?
    var onErrorHandler: ((String) -> Void)?

    let httpUtility = WebService()
    
    let recahbility = rechabilityModel()
    
   
    func fetchData(request:uploadProfilePictureRequest)
    {
        
        self.onStartLoading?()
      
        httpUtility.NetworkCallValidation(requestUrl: ApiEndpoints.UploadProfilePic, Method: .post, requestBody:request.dictionary, resultType: String.self){[weak self](ApiResponse,error)  in
                self?.onStopLoading?()
       
                if(error == nil)
                {
                  
                    self?.onSuccessHandler!(true).self
                    
                }
                else
                {
                    self?.onErrorHandler?(error ?? "02")
                 
                    self?.onStopLoading?()
                }
            }
      
            
     
        
    }
    
}
