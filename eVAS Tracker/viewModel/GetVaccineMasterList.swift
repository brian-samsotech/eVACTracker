//
//  GetVaccineMasterList.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
class GetVaccineMasterList:NSObject
{
    
    var onStartLoading: (() -> Void)?
    var onStopLoading: (() -> Void)?
    var onSuccessHandler: (([VaccinationStatusModel]) -> Void)?
    var onErrorHandler: ((String) -> Void)?

    let httpUtility = WebService()
    
    let recahbility = rechabilityModel()
    
   
    func fetchData()
    {
        
        self.onStartLoading?()
      
        httpUtility.NetworkCallArray(requestUrl: "\(ApiEndpoints.GetVaccineMasterList)", Method: .get, requestBody:nil, resultType: [VaccinationStatusModel].self){[weak self](ApiResponse,error)  in
                self?.onStopLoading?()
       
                if(error == nil)
                {
                  
                    if(ApiResponse != nil)
                    {
             
                        do {
                                  let data = try JSONSerialization.data(withJSONObject: ApiResponse! , options: .prettyPrinted)
                                  
                                  let responseData = try JSONDecoder().decode([VaccinationStatusModel].self, from: data)
                
                         print("data 123\(responseData)")
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
