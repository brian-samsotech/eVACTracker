//
//  DoseMasterViewModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import Foundation
class DoseMasterViewModel:NSObject
{
    
    var onStartLoading: (() -> Void)?
    var onStopLoading: (() -> Void)?
    var onSuccessHandler: (([DoseMasterModel]) -> Void)?
    var onErrorHandler: ((String) -> Void)?

    let httpUtility = WebService()
    
    let recahbility = rechabilityModel()
    
   
    func fetchData()
    {
        
        self.onStartLoading?()
      
        httpUtility.NetworkCallArray(requestUrl: "\(ApiEndpoints.GetDoseMaster)", Method: .get, requestBody:nil, resultType: [DoseMasterModel].self){[weak self](ApiResponse,error)  in
                self?.onStopLoading?()
       
                if(error == nil)
                {
                  
                    if(ApiResponse != nil)
                    {
             
                        do {
                                  let data = try JSONSerialization.data(withJSONObject: ApiResponse! , options: .prettyPrinted)
                                  
                                  let responseData = try JSONDecoder().decode([DoseMasterModel].self, from: data)
                
                         print(responseData)
                          self?.onSuccessHandler!(responseData).self
                 
                       
                              
                              }
                        catch _{
                                
                            self?.onErrorHandler?("02")
                             
                                self?.onStopLoading?()
                              
                              }
                    }
                    else
                    {
                    self?.onErrorHandler?("02")
                     
                        self?.onStopLoading?()
                    }
                    
                }
                else
                {
                    self?.onErrorHandler?(error ?? "02")
                 
                    self?.onStopLoading?()
                }
            }
      
            
     
        
    }
    
}
